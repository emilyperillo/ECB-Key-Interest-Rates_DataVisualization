<img width="910" height="546" alt="image" src="https://github.com/user-attachments/assets/52ca0bfa-887c-40f4-9f6e-92b245e715a9" />![cover_desktop_calling-time-on-the-european-central-bank]

# ECB Key Interest Rates Analysis 📉
### From Negative Interest Rates to All-Time Highs (1999 - 2025)

![R](https://img.shields.io/badge/R-tidyverse-blue?logo=r&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-Public-E97627?logo=tableau&logoColor=white)
![License](https://img.shields.io/badge/License-CC%20BY--NC%204.0-green)

---

## Project Overview

This repository hosts a data visualization pitch and the relative R code regarding the **European Central Bank (ECB) Monetary Policy**. The project questions the main effects of central bank decisions by visualizing the trends of the three Key Interest Rates over the last two decades.

The analysis focuses on:
* **Historical Trends:** Identifying periods of stability, cuts, and hikes.
* **Correlation:** Analyzing the relationship between the three key rates.
* **Inflation Response:** Understanding how quickly the ECB adapts rates in response to inflation shocks (e.g., the 2022 crisis).

---

## The Three Key Rates
The analysis investigates the evolution of the specific instruments used by the ECB to maintain price stability (2% inflation target):

1.  **Main Refinancing Operations (MRO):** The rate banks pay when borrowing money from the ECB for one week.
2.  **Deposit Facility:** The rate banks receive (or pay, in case of negative rates) for overnight deposits.
3.  **Marginal Lending Facility:** The rate banks pay to borrow overnight (the highest rate).

---

## Visualizations & Key Findings

The project utilizes **RStudio** for static analysis and **Tableau** for interactive exploration.

### 1. Semestral Analysis (Cuts vs Hikes)
We analyzed the "Negative Interest Era" (2014-2022) where the Deposit Facility Rate dropped below zero to stimulate the economy, contrasted with the post-pandemic aggressive hikes to counter inflation.

### 2. Correlation Matrix
A Scatter Plot Matrix was generated to demonstrate that the three rates are **strongly positively correlated**. When one is subject to a hike, the others follow, ensuring market stability and preventing distortion.

### 3. Reaction to Inflation
The visualization highlights a significant lag (12-18 months) between inflation spikes and ECB intervention. This cautious approach is designed to distinguish temporary shocks from structural inflation risks.

---

## 🛠️ Tech Stack & Methodology

* **RStudio:** Used for data cleaning, manipulation (`tidyverse`), and static plotting (`ggplot`).
* **Tableau Public:** Used for creating the interactive Scatter Plot Matrix.
* **Data Sources:** Official datasets from the **European Central Bank (ECB) Data Portal**.

### Datasets Used
* *Main refinancing operations - fixed & variable rate tenders*
* *Deposit facility date of changes*
* *Marginal lending facility*
* *Harmonized Index of Consumer Prices (HICP)*

---

## Disclaimer & License

**Author:** Emily Perillo  
**License:** [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/)

> The original datasets belong to the **European Central Bank** and any manipulation of its data cannot be reconducted to the institution in any way. All rights regarding the visualization and code belong to the author.

This project was developed for the *Data Visualization* course.
