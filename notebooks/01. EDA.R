# Load data
setwd("C:/Users/hp/Desktop/AD OPTIMIZATION/notebooks")
advert <- read.csv("C:/Users/hp/Desktop/AD OPTIMIZATION/data/advertising.csv")
colnames(data)
head(data)
str(advert)
summary(advert)

# Check for missing values
colSums(is.na(advert))

# Distribution of spend per channel

hist(advert$TV, main = "TV Spend Distribution", xlab = "TV")
hist(advert$Radio, main = "Radio Spend Distribution", xlab = "Radio")
hist(advert$Newspaper, main = "Newspaper Spend Distribution", xlab = "Newspaper")

# Correlation with Sales
cor(advert)
cor(advert)["Sales", ]

# Scatterplots to eyeball linearity (relevant later — regression assumes linear relationships)
plot(advert$TV, advert$Sales, main = "TV vs Sales", xlab = "TV", ylab = "Sales")
abline(lm(Sales ~ TV, data = advert), col = "red")

plot(advert$Radio, advert$Sales, main = "Radio vs Sales", xlab = "Radio", ylab = "Sales")
abline(lm(Sales ~ Radio, data = advert), col = "red")

plot(advert$Newspaper, advert$Sales, main = "Newspaper vs Sales", xlab = "Newspaper", ylab = "Sales")
abline(lm(Sales ~ Newspaper, data = advert), col = "red")


# Current average spend split (B)
avg_spend <- colMeans(advert[, c("TV", "Radio", "Newspaper")])
print(avg_spend)

baseline_B <- sum(avg_spend)
cat("Implied baseline budget B =", baseline_B, "\n")