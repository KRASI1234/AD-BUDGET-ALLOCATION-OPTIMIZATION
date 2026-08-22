# Load data
setwd("C:/Users/hp/Desktop/AD OPTIMIZATION/data")
advert <- read.csv("advertising.csv")
colnames(data)
head(data)
str(advert)
summary(advert)

# Check for missing values
colSums(is.na(advert))

# Distribution of spend per channel
par(mfrow = c(1, 3))
hist(advert$TV, main = "TV Spend Distribution", xlab = "TV")
hist(advert$Radio, main = "Radio Spend Distribution", xlab = "Radio")
hist(advert$Newspaper, main = "Newspaper Spend Distribution", xlab = "Newspaper")
par(mfrow = c(1, 1))

# Correlation with Sales
cor(advert)
cor(advert)["Sales", ]

# Scatterplots to eyeball linearity (relevant later — regression assumes linear relationships)
par(mfrow = c(1, 3))
plot(advert$TV, advert$Sales, main = "TV vs Sales", xlab = "TV", ylab = "Sales")
abline(lm(Sales ~ TV, data = advert), col = "red")

plot(advert$Radio, advert$Sales, main = "Radio vs Sales", xlab = "Radio", ylab = "Sales")
abline(lm(Sales ~ Radio, data = advert), col = "red")

plot(advert$Newspaper, advert$Sales, main = "Newspaper vs Sales", xlab = "Newspaper", ylab = "Sales")
abline(lm(Sales ~ Newspaper, data = advert), col = "red")
par(mfrow = c(1, 1))

# Current average spend split (candidate baseline for B later)
avg_spend <- colMeans(advert[, c("TV", "Radio", "Newspaper")])
print(avg_spend)

baseline_B <- sum(avg_spend)
cat("Implied baseline budget B =", baseline_B, "\n")