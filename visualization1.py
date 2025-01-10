import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv('data/final_data/model_data.csv')

# Calculate correlations and get top/bottom correlations
numeric_columns = df.select_dtypes(include=['number'])
numeric_corr = numeric_columns.corr()

# Get the upper triangle of the correlation matrix to avoid duplication
upper_triangle = numeric_corr.where(np.triu(np.ones(numeric_corr.shape), k=1).astype(bool))

# Unstack the upper triangle matrix and sort the values
sorted_correlations = upper_triangle.stack().sort_values()

# Get the top 3 highest and bottom 3 lowest correlations
top_possitive = sorted_correlations.tail(3)
top_negative = sorted_correlations.head(3)

# Combine them into a DataFrame for easy plotting
correlation_to_plot = pd.concat([top_possitive, top_negative])

# Save heatmap visualization of the selected correlations
plt.figure(figsize=(8, 6))
sns.heatmap(correlation_to_plot.values.reshape(1, -1), annot=True, cmap='coolwarm', center=0, 
            xticklabels=correlation_to_plot.index, yticklabels=["Correlation"])
plt.xticks(rotation=45, ha='right')  # Rotate and align x-axis labels to the right
plt.title("Top Positive and Negative Correlations")
plt.tight_layout()
plt.savefig('visuals/top_positive_negative_correlations_heatmap.png')  # Save the heatmap as an image
plt.close()  # Close the plot to avoid displaying it

# Extract individual features from tuples
top_positive_features = set([feature for feature_pair in top_possitive.index for feature in feature_pair])
top_negative_features = set([feature for feature_pair in top_negative.index for feature in feature_pair])

# Save pairplot visualization for the highest and lowest correlations

# Positive correlations
sns.pairplot(df[list(top_positive_features)], plot_kws={'alpha': 0.7, 's': 50, 'edgecolor': 'black'})
plt.suptitle("Top Positive Correlations", y=1.02)
plt.savefig('visuals/top_positive_correlations_pairplot.png')  # Save the pairplot as an image
plt.close()  # Close the plot to avoid displaying it

# Negative correlations
sns.pairplot(df[list(top_negative_features)], plot_kws={'alpha': 0.7, 's': 50, 'edgecolor': 'black'})
plt.suptitle("Top Negative Correlations", y=1.02)
plt.savefig('visuals/top_negative_correlations_pairplot.png')  # Save the pairplot as an image
plt.close()  # Close the plot to avoid displaying it
