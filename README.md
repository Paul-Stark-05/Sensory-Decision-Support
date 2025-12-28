# Sensory Data Analysis & Decision Support Tool (R Shiny)

## 📌 Project Overview
This project mimics a **Sensory Analysis workflow** typical in the perfume and flavor industry. 
Using the Wine Quality dataset as a proxy for sensory panel data, this R Shiny dashboard allows stakeholders to:
1.  **Visualize correlations** between physicochemical properties (formulation) and human sensory scores (perception).
2.  **Filter production batches** based on specific attributes.
3.  **Automate decision-making** by calculating pass/fail rates against quality thresholds.

## 🎯 Business Value
* **Reduced Analysis Time:** Automates the visualization of large sensory datasets.
* **Decision Support:** Provides instant "Go/No-Go" metrics for production batches based on sensory KPIs.
* **Statistical Rigor:** Uses regression trends to identify which chemical drivers most influence consumer preference.

## 🛠 Tech Stack
* **Language:** R
* **Interactive Framework:** R Shiny
* **Visualization:** ggplot2
* **Data Manipulation:** dplyr

## 🚀 How to Run
1. Open `app.R` in RStudio.
2. Click "Run App".
3. The dataset is fetched automatically from the UCI Machine Learning Repository.
