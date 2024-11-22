# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# Instructions to ChatGPT:
# I have a data file with a single header line and six lines of data. 
# Field 1 lists the same of a sequence, field 2 contains the sequence,
# and the rest of the fields contain the probability of an exon at each
# site in the sequence, with one column per site. 
# Write R code to plot the data, with each line in a different facet (ncol = 1)

# Read in the data (adjust file path and delimiter as necessary)
data <- read.csv("~/SegmentNToutput_region_B71.csv", header=TRUE)  # Use read.delim() if it's tab-delimited

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = starts_with("ExonProb"),   # Adjust if the probability columns have a different name
               names_to = "site", 
               values_to = "probability") %>%
  mutate(site = as.integer(gsub("ExonProb", "", site)))  # This removes the 'V' from the site column names if necessary

# Create the plot
ggplot(data_long, aes(x = site, y = probability)) +
  geom_line() +  # You could also use geom_point() if you'd prefer points
  facet_wrap(~ SegName, scales = "free_y", ncol = 1) +  # Facet by sequence name
  labs(x = "Site", y = "Exon Probability") +
  theme_minimal() +
  theme(strip.text = element_text(size = 10))  # Adjust text size in facet labels if needed
