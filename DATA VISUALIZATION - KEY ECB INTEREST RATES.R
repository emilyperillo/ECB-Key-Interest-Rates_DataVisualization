rm(list=ls())
cat("\014")

setwd("C:/Users/Emily/Desktop/DATA VISUALIZATION")
getwd()
dir()

library(tidyverse)
library(readxl)
library(ggplot2)

# Merging of MRO datasets and creation of dataframe for plots -------------
MRO = read_excel("MAIN REFINANCING OPERATIONS BCE.xlsx") |> select(1, 3) |> 
  setNames(c("DATE", "value")) |> mutate(Type = "Fixed")

MROVARIABLE = read_excel("MRO VARIABLE.xlsx") |> select(1, 3) |> setNames(c("DATE", "value")) |> mutate(Type = "Variable")

MROTOTAL <- bind_rows(MRO, MROVARIABLE) |> arrange(DATE) |> mutate(Legend = "Main Refinancing Operations")

DF = read_excel("DEPOSIT FACILITY BCE.xlsx") |> rename(value="Deposit facility - date of changes (raw data) - Level (FM.D.U2.EUR.4F.KR.DFR.LEV)") |> mutate(Legend = "Deposit Facility")

MLF = read_excel("MARGINAL LENDING FACILITY BCE.xlsx") |> rename(value="Marginal lending facility - date of changes (raw data) - Level (FM.D.U2.EUR.4F.KR.MLFR.LEV)") |> mutate(Legend = "Marginal Lending Facility")

df <- bind_rows(MROTOTAL, DF, MLF)


# Historical Series -------------------------------------------------------
ggplot(df, aes(x = DATE, y = value, color = Legend)) +
  #geom_step does not recreate the decreasing line between 2000 and 2008 for fixed mro 
  geom_step(linewidth = 0.6, alpha = 0.8) +
  
  scale_x_date(
    limits = c(as.Date("1999-01-01"),as.Date("2025-12-21")),
    date_breaks = "2 years",     
    date_labels = "%Y"          
  ) +
  
  scale_color_manual(values = c(
    "Main Refinancing Operations" = "darkred", 
    "Deposit Facility" = "#FFCC00", 
    "Marginal Lending Facility" = "darkgreen" 
  )) +
  
  scale_y_continuous(
    breaks = seq(floor(min(df$value, na.rm = TRUE)), 
                 ceiling(max(df$value, na.rm = TRUE)), 
                 by = 0.5)
  ) + 
  theme_classic() +
  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
    plot.subtitle = element_text(hjust = 0.5, size = 10),
    plot.title.position = "plot",
    plot.subtitle.position = "plot",
    legend.position = "bottom",
    legend.title = element_blank()
  ) +
  
  labs(
    title = "Historical Series Comparison: ECB Key Interest Rates",
    subtitle = "01 January 1999 - 21 December 2025",
    x = "Year",
    y = "Value (Basis Points)"
  )



# Inflation and Key Interest Rates ---------------------------------------
hicp = read_excel("Dati_Completi_Tassi_HICP.xlsx")

hicplong <- hicp|>
  select(DATE, `Main Refinancing Operations`, `Deposit Facility`, `Marginal Lending Facility`, `HICP - Overall index`) |>
  pivot_longer(cols = -DATE, names_to = "Type", values_to = "Value")

ggplot() +
  geom_area(data = filter(hicplong, Type == "HICP - Overall index"), aes(x = DATE, y = Value), fill = "grey80", alpha = 0.5) +
  geom_line(data = filter(dehoizalong, Type != "HICP - Overall index"), aes(x = DATE, y = Value, color = Type), linewidth = 1) +
  scale_color_manual(values = c(
    "Main Refinancing Operations" = "#4575b4", 
    "Deposit Facility" = "#d73027",            
    "Marginal Lending Facility" = "#fee090"  
  )) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(
    title = "How fastly does the ECB react to changes of inflation?",
    y = "Value (Basis Points)",
    x = NULL,
    color = "Key Interest Rates"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom", 
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
        plot.title.position = "plot")

# Plot of Hikes and Cuts ----------------------------------------------------------
df_unified <- df |>
  mutate(Legend = case_when(
    grepl("Main Refinancing", Legend) ~ "Main Refinancing Operations",
    TRUE ~ Legend 
  )) |>
  mutate(Semester = floor_date(DATE, "6 months")) |>
  arrange(Legend, DATE) |>
  group_by(Legend, Semester) |>
  summarise(value = last(value), .groups = "drop") |>
  arrange(Legend, Semester) |>
  group_by(Legend) |>
  mutate(
    next_value = lead(value),
    next_date  = lead(Semester),
    diff = next_value - value,
    direction = case_when(
      diff > 0 ~ "Hike",
      diff < 0 ~ "Cut",
      TRUE ~ "Stable"
    )
  ) |>
  filter(!is.na(next_date)) |>
  ungroup()

perlineeorizzontali <- df_unified
df_vert  <- df_unified |> filter(diff != 0)

formatta_semestri <- function(x) {
  month <- as.numeric(format(x, "%m"))
  year <- format(x, "%Y")
  labelll <- ifelse(month <= 6, "1° Semester", "2° Semester")
  
  paste(labelll, year)
}

ggplot() +
  geom_segment(data = perlineeorizzontali,
               aes(x = Semester, xend = next_date, y = value, yend = value),
               color = "lightgrey", linewidth = 1) + 
  geom_segment(data = df_vert,
               aes(x = next_date, xend = next_date, 
                   y = value, yend = next_value, 
                   color = direction),
               linewidth = 1.5) + 
  geom_point(data = df_vert,
             aes(x = next_date, y = next_value, color = direction),
             size = 2.5) +
  facet_wrap(~Legend, ncol = 1, scales = "free_y") + 
  scale_color_manual(values = c("Hike" = "#00C853", "Cut" = "#D50000")) +
  scale_x_date(
    limits = c(as.Date("1999-01-01"), as.Date("2025-12-31")),
    date_breaks = "6 months", 
    labels = formatta_semestri,
    expand = c(0, 0)
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    strip.text = element_text(face = "bold", size = 12, color = "#2C3E50"),
    strip.background = element_blank(),
    legend.position = "bottom",
    panel.grid.major.y = element_line(color = "grey92"),
    axis.text.x = element_text(angle = 90, hjust = 1)
  ) +
  
  labs(
    title = "ECB Key Interest Rates: Semestral Analysis",
    x = NULL, 
    y = "Rate variation (Basis Points)",
    color = "Policy Action"
  )