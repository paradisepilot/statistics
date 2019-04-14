
getEventHistories <- function(
    seed            = 1234567,
    DateTime.start  = lubridate::ymd_hms("2004-01-01 00:00:00", quiet = TRUE, tz = "America/Vancouver"),
    DateTime.end    = lubridate::ymd_hms("2016-12-31 23:59:59", quiet = TRUE, tz = "America/Vancouver"),
    N               = 10000,
    alpha0          = 0.25,
    population.flag = "01"
    ) {

    require(lubridate)

    set.seed(seed);

    names.series <- c(
        "opioid.deaths",
        "opioid.overdoses",
        "opioid.prescriptions",
        "police.arrests"
        );

    event.histories <- list();
    for ( temp.series in names.series ) {
        event.histories[[ temp.series ]] <- getOneEventHistory(
            DateTime.start = DateTime.start,
            DateTime.end   = DateTime.end
            );
        }

    return( event.histories );

    }

##### ##### ##### ##### ##### ##### ##### #####
getOneEventHistory <- function(
    DateTime.start = NULL,
    DateTime.end   = NULL
    ) {

    n.events <- rpois(n = 1, lambda = 10);
    n.days   <- as.integer( DateTime.end - DateTime.start );

    event.dates <- as_date(DateTime.start) + sample(x = seq(0,n.days), size = n.events, replace = TRUE);
    event.dates <- as_datetime(event.dates, tz = tz(DateTime.start));

    event.DateTimes <- event.dates + sample(x = seq(0,86400), size = n.events, replace = TRUE);

    return( event.DateTimes );

    }

