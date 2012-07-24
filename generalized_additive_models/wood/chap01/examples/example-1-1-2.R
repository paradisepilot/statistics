
library(gamair);
data(hubble);

hubble.model <- lm( formula = y ~ x, data = hubble );
summary(hubble.model);

png("hubble-fitted-vs-residuals.pdf");
plot(
	x    = fitted(hubble.model),
	y    = residuals(hubble.model),
	xlab = "fitted values",
	ylab = "residuals"
	);
dev.off();

