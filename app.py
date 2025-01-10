import joblib
import numpy as np
import pandas as pd
from flask import Flask, request, jsonify
from datetime import datetime
import requests  # Added to make API calls

# Initialize Flask app
app = Flask(__name__)

# Load the saved model and encoder
model = joblib.load('updated_random_forest_model.pkl')
encoder = joblib.load('ordinal_encoder.pkl')

# Define feature names (these should match the features used for training the model)
feature_names = ['Barcode', 'tempmax', 'tempmin', 'temp', 'feelslikemax', 'feelslikemin', 
                 'feelslike', 'dew', 'humidity', 'precip', 'precipprob', 'precipcover', 
                 'snow', 'snowdepth', 'windgust', 'windspeed', 'winddir', 'sealevelpressure', 
                 'cloudcover', 'visibility', 'solarradiation', 'solarenergy', 'uvindex', 
                 'severerisk', 'moonphase']

# Corrected API URL
API_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Bristol?unitGroup=metric&include=days&key=64YD4JMWZBBMEZKMXE8M87AGV&contentType=json"

# Function to get weather data for the next 15 days
def get_weather_data():
    try:
        # Call the Visual Crossing API to get weather data for the next 15 days
        response = requests.get(API_URL)
        
        # Log the status code and response content for debugging
        print(f"Weather API Response Status: {response.status_code}")
        print(f"Weather API Response Content: {response.text}")
        
        # Check for valid response
        if response.status_code != 200:
            raise Exception(f"Failed to fetch weather data. Status code: {response.status_code}")
        
        # Ensure the response is valid JSON
        weather_data = response.json()

        # Extract daily weather data for the next 15 days
        future_weather = []
        for day in weather_data['days'][:15]:  # Get the next 15 days
            day_data = {
                'tempmax': day.get('tempmax', 0),
                'tempmin': day.get('tempmin', 0),
                'temp': day.get('temp', 0),
                'feelslikemax': day.get('feelslikemax', 0),
                'feelslikemin': day.get('feelslikemin', 0),
                'feelslike': day.get('feelslike', 0),
                'dew': day.get('dew', 0),
                'humidity': day.get('humidity', 0),
                'precip': day.get('precip', 0),
                'precipprob': day.get('precipprob', 0),
                'precipcover': day.get('precipcover', 0),
                'snow': day.get('snow', 0),
                'snowdepth': day.get('snowdepth', 0),
                'windgust': day.get('windgust', 0),
                'windspeed': day.get('windspeed', 0),
                'winddir': day.get('winddir', 0),
                'sealevelpressure': day.get('sealevelpressure', 0),
                'cloudcover': day.get('cloudcover', 0),
                'visibility': day.get('visibility', 0),
                'solarradiation': day.get('solarradiation', 0),
                'solarenergy': day.get('solarenergy', 0),
                'uvindex': day.get('uvindex', 0),
                'severerisk': day.get('severerisk', 0),
                'moonphase': day.get('moonphase', 0)
            }
            future_weather.append(day_data)
        
        return pd.DataFrame(future_weather)

    except Exception as e:
        raise Exception(f"Error fetching weather data: {str(e)}")

# Prediction endpoint
@app.route('/predict_sales', methods=['POST'])
def predict_sales():
    """
    Endpoint to predict sales.
    The request must contain a JSON with barcodes and weather forecast data.
    """
    try:
        # Get data from the POST request
        data = request.get_json()
        
        # Extract barcodes and weather data from the request
        barcodes = data['barcodes']
        # future_weather = pd.DataFrame(data['weather'])
        future_weather = get_weather_data();

        predictions = {}

        for barcode in barcodes:
            # Encode the barcode
            encoded_barcode = encoder.transform(pd.DataFrame({'Barcode': [barcode]}))[0, 0]
            
            total_sales_week = 0
            
            # Predict for each day in the future weather forecast
            for index, day_weather in future_weather.iterrows():
                # Prepare input data for the model
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
                ]], columns=feature_names)
                
                # Predict sales for this day
                predicted_sales = model.predict(input_data)
                
                # Sum up the sales for the week
                total_sales_week += predicted_sales[0]

            # Store the total predicted sales for this product barcode
            predictions[barcode] = np.ceil(total_sales_week)  # Round up the sales

        return jsonify(predictions)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)