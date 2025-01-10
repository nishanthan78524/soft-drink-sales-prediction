import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OrdinalEncoder
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error
import numpy as np
from datetime import datetime
import joblib

# Load data
df = pd.read_csv('data/final_data/model_data.csv')

# Ordinal Encoding for categorical features
encoder = OrdinalEncoder()
df['Barcode'] = encoder.fit_transform(df[['Barcode']])  # Encode 'Barcode'

# Select relevant features and the target variable
X = df[['Barcode', 'tempmax', 'tempmin', 'temp', 'feelslikemax',
        'feelslikemin', 'feelslike', 'dew', 'humidity', 'precip',
        'precipprob', 'precipcover', 'snow', 'snowdepth', 'windgust',
        'windspeed', 'winddir', 'sealevelpressure', 'cloudcover',
        'visibility', 'solarradiation', 'solarenergy', 'uvindex',
        'severerisk', 'moonphase']]
y = df['Quantity Sold']

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Model Training
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluation (for reference)
y_pred = model.predict(X_test)
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2_score = model.score(X_test, y_test)
print(f"Model Evaluation -> MAE: {mae}, RMSE: {rmse}, R^2: {r2_score}")

# Function to predict sales for a given week
def predict_future_sales(barcodes, future_weather):
    """
    Predict future sales for a list of barcodes for the upcoming week.
    
    Parameters:
    - barcodes: List of product barcodes to predict.
    - future_weather: Pandas DataFrame containing weather forecast for the next 7 days.
    
    Returns:
    - predictions: Dictionary with product barcodes as keys and predicted sales (7-day total) as values.
    """
    predictions = {}

    for barcode in barcodes:
        # Encode the barcode (ensure proper reshaping)
        encoded_barcode = encoder.transform(np.array([[barcode]]))[0, 0]
        
        total_sales_week = 0
        
        # Predict for each day in the future weather forecast
        for index, day_weather in future_weather.iterrows():
            # Prepare input data for each day (barcode + weather)
            input_data = pd.DataFrame([[
                encoded_barcode,
                day_weather['tempmax'],
                day_weather['tempmin'],
                day_weather['temp'],
                day_weather['feelslikemax'],
                day_weather['feelslikemin'],
                day_weather['feelslike'],
                day_weather['dew'],
                day_weather['humidity'],
                day_weather['precip'],
                day_weather['precipprob'],
                day_weather['precipcover'],
                day_weather['snow'],
                day_weather['snowdepth'],
                day_weather['windgust'],
                day_weather['windspeed'],
                day_weather['winddir'],
                day_weather['sealevelpressure'],
                day_weather['cloudcover'],
                day_weather['visibility'],
                day_weather['solarradiation'],
                day_weather['solarenergy'],
                day_weather['uvindex'],
                day_weather['severerisk'],
                day_weather['moonphase']
            ]], columns=X.columns)  # Ensure column names match the training set
            
            # Predict sales for this day
            predicted_sales = model.predict(input_data)
            
            # Sum up the sales for the week
            total_sales_week += predicted_sales[0]

        # Store the total predicted sales for this product barcode
        predictions[barcode] = total_sales_week
    
    return predictions

df = pd.read_csv('data/weather_forecast_new.csv')

# Avoiding the SettingWithCopyWarning by using .loc[] when modifying the DataFrame
df.loc[:, 'datetime'] = pd.to_datetime(df['datetime'])

# Function to filter one week of data from a specific date
def filter_week_data(requested_date):
    # Convert the requested date to datetime
    requested_date = pd.to_datetime(requested_date)
    
    # Get the data within one week from the requested date
    filtered_df = df[(df['datetime'] >= requested_date) & 
                     (df['datetime'] < requested_date + pd.Timedelta(days=7))]
    return filtered_df

# Get the current system date
system_date = datetime.now().date()  # Or use pd.Timestamp.today().date()

# Example usage: Filter data for the week starting from the system date
week_data = filter_week_data(system_date)

# Example Usage
future_weather = week_data

# Array of product barcodes to predict sales for
barcodes = [5020379173865, 5060896623276, 5010437021931]  # Example barcodes

# Call the prediction function
predicted_sales = predict_future_sales(barcodes, future_weather)

# Output the predicted sales for each barcode, rounding up to the next full integer
for barcode, sales in predicted_sales.items():
    rounded_sales = np.ceil(sales)  # Round up the sales to the next integer
    print(f"Predicted total sales for Barcode {barcode} over the next week: {int(rounded_sales)}")

# Save the model and encoder using joblib
#joblib.dump(model, 'updated_random_forest_model.pkl')  # Save the model as a .pkl file
#joblib.dump(encoder, 'ordinal_encoder.pkl')    # Save the encoder
