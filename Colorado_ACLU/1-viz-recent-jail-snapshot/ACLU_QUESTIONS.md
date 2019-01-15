# A place to write questions that come up about the pretrial snapshot data to be addressed by the CO ACLU contact(s) 

General note: (derived from the notes provided in the data) I get the sense that these data do not have high reliability; the notes indicate all sorts of decision that must have been made to come up with these counts. Not sure what can be done about this or if it's even worth it to bring it up but it seems like whoever entered the data had to make a lot of decision about what counts under what columns

## pretrial overview sheet questions
- can we get a description of the columns? Particularly of interest are these:
`# Parole Hold (1)`,	`Combined Misdo/Felony PT LOS (days)`,	`Misdo Mean/Avg PT LOS 2017`,	`Misdo Median PT LOS 2017`,	`Misdo Mode PT LOS 2017`,	`Felony Mean/Avg LOS PT 2017`,	`Fel Median PT LOS 2017`,	`Fel Mode PT LOS 2017`
  - specifically here, what does "mean average" signify
- footnotes appear to be missing, lines 5, 56
- what does (8) mean for denver city jail and denver county jail?
- there are *many* different approaches for missing data, any clarity about how we should treat the different approaches would be appreciated (instances and our solutions inventoried below)
- there are ranges in the data under columns that indicate the data should be scalars (e.g., segwick county has ranges, not scalars), any clarity would be appreciated there
- what does the `(1)` in the column `# Parole Hold (1)` mean

## racial ethnic data
- how can a count of people be anything but an integer? See pueblo county data for examples of non-integer numeric data 
- What is the AK ethnicity?
- Where the counties had no jail, sometimes this was left blank and sometimes it was `n/a`, we should probably treat all of these as `NULL`, right?
- why does dolores county have data despite not having any data (and no jail) in the pretial overivew sheet?

## hold breakdowns

- non-integer numeric data

## Notes about the data cleaning

### Pretrial overview
all "hover notes" were transcribed in a new `notes` column and deleted from the original location, if no column is listed, the notes came from the `county_or_jail` column. We could also add these in to increase clarity 

when notes did not appear in the `county_or_jail` column, the column they came from was prepended

where footnotes were indicated, they were added to the notes prepended with the column location
tried to make column names sensible (still have questions about meaning here though)

Missing data treatment
- Not applicable blanks were filled with `NULL`
- missing data blanks were filled with `NA`
- `n/a`s replaced with `NULL`
- unspecified blanks replaced with `NA`
- `Unasked` replaced with `NA`
- `they don't track` replaced with `NA`
- `unknown` replaced with `NA`
- `requested` replaced wit `NA`

### racial/ethnic data

tried to make column names sensible

the missing data here was not handled consistenly

All counties/jails that had null data in the pretrial overview sheet (due to NO JAIL) were made `NULL` in this sheet. Some of these were left blank, some of these were indicated with `n/a`, **some of these had data!** For the latter, these data were left in place.

Missing/Confounded data treatment
- `replied "unknown"` changed to `NA`
- `unknown` changed to `NA`
- `n/a` changed to `NULL` **except:**
- `n/a` changed to `NA` for Huefano County (because there should be data
- blanks changed to `NA`, but some changed to `NULL` depending on data presence in the pretrial snapshot sheet

### hold breakdowns

Hover notes added to notes column, source column specified if not from the `county_or_jail` column

Missing data treatment
- blanks to `NA`
-`N/A` to `NA`
- `n/a` to `NA`
- `replied "unknown"` to `NA`
- `possibly some of the 19 are parole` to `NA`


