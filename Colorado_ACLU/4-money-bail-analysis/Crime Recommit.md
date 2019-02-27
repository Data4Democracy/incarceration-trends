<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__html"><h1 id="whos-behind-the-bars">Who’s behind the bars?</h1>
<h3 id="how-dangerous-are-people-liberated-on-money-bail">How dangerous are people liberated on money bail</h3>
<p>Each year, thousands of people land in a US County jail. While some spend their nights behind the bars counting hours to freedom, only in vain, others breathe the air of freedom soon enough by getting a bail. But is ensuring a defendant’s appearance at trial by requiring him to post a bond or, in effect, make a promise to appear, the right move?</p>
<p>This report will focus on the trends in recommits of crime when out on bail giving a comparision between trends when the bond is given in cash v/s those in PR- bond . This report aims to give the public and policymakers the foundation for a more informed discussion about whether requiring thousands of dollars in bail bonds makes sense given the number of crimes recomitted over the years.</p>
<p><strong>What follows is an analysis of nearly three years of data that provides a glimpse at how often people facing charges were accused of committing new crimes while out on bail.</strong></p>
<h1 id="methodology">Methodology</h1>
<p>The data for incarceration trends comes from Vera Institute for justice. Data from 2014-2016 has been used in this report. Together, this report studies the trends of recommits in crime on a county wise basis and also segregates it on the basis of the type of crime (Misdemeanor, Felony).</p>
<p>To make the data accessible for the codes, it was converted from .csv to a dataframe wherein normalized counts were calculated for recommits wrt each year on the basis of the kind of crime. This was done by :</p>
<ol>
<li>Adding up the counts for money bonds posted to pr bonds posted for each county for each year.</li>
<li>Number of recommits( county wise, segregated on the basis of crime ) was then divided by the total number of posted bonds</li>
</ol>
<h1 id="analysis">Analysis</h1>
<ol>
<li>The % counts of recommits ranges from around 15-30% in case of Midemeanor which increases to around 50% when Felony charges are considered.</li>
<li>For some counties, count is as high as 50 recommits per month</li>
<li>The difference between % of crimes recomitted when person is out on money bond and pr bond is around 10% on an average. For some counties, like Larimer, the count difference is as big as 2705!</li>
<li>The number of money bonds posted in counties with high poverty rate(# money bonds posetd: 7-20) is nothing when compared to those with low poverty rate(# money bonds posetd: 5000). This shows that criminals in low income area are usually denied freedom because of not being able to afford the amount of cash bond.</li>
</ol>
<h1 id="detailed-results-and-insights">Detailed Results and Insights</h1>
<blockquote>
<p>Here’s a plot of % of people charged for a crime who were accused of recommitting crimes after being release on bail.</p>
</blockquote>
<p>The chart illustrates the year wise rate of recomiits in crime in counties when not in detention. This report focuses on this important population: those who are liberated because they could afford the money bail and then went out to recommit crimes all over again.</p>
<h4 id="misdemenaor">Misdemenaor</h4>
<div>
    <a href="https://plot.ly/~thechange/42/?share_key=YAKhH9yqZREmIBblcBFopU" target="_blank" title="N14"><img src="https://plot.ly/~thechange/42.png?share_key=YAKhH9yqZREmIBblcBFopU" alt="N14" width="600"></a>
    
</div>
<h4 id="felony">Felony</h4>
<div>
    <a href="https://plot.ly/~thechange/44/?share_key=OLmpZgT6jHwZPs0kYft0P9" target="_blank" title="NF14"><img src="https://plot.ly/~thechange/44.png?share_key=OLmpZgT6jHwZPs0kYft0P9" alt="NF14" width="600"></a>
    
</div>
<p>As can be seen in the plot, the rate of recommits is only increasing by the year in most counties( e.g. Montrose, Archuleta) and is also more than <strong>10% on an average</strong>. But that is not it, on a comparision, it was seen that the rate of recommits for felony was much higher that that for misdemeanor. The numbers tell that on an average the number of felony recommints in a county like Denver and El Paso was <strong>close to 600, which means around 50 recommits per month</strong>.</p>
<p>There has been a significant, nationwide move away from courts allowing non-financial forms of pretrial release (such as release on own recognizance) to money bail, although this does vary substantially depending on jurisdiction.  Let’s now dig deeper and find out what kind of bonds was the release based on.</p>
<h2 id="misdemeanor">Misdemeanor</h2>
<blockquote>
<p>Below is a comparison of number of recommits when the bail was given on Money bond v/s that when it involved a PR bond (for Misdemeanor)</p>
</blockquote>
<h4 id="year-2014">Year 2014</h4>
<div>
    <a href="https://plot.ly/~thechange/46/?share_key=jGiT2X89cY8XEgm0cbJqYN" target="_blank" title="MP14"><img src="https://plot.ly/~thechange/46.png?share_key=jGiT2X89cY8XEgm0cbJqYN" alt="MP14" width="600"></a>
    
</div>
<h4 id="year-2015">Year 2015</h4>
<div>
    <a href="https://plot.ly/~thechange/10/?share_key=GrQurTCZu7T1S6Giy3qpwS" target="_blank" title="MP15"><img src="https://plot.ly/~thechange/10.png?share_key=GrQurTCZu7T1S6Giy3qpwS" alt="MP15" width="600"></a>
    
</div>
<h4 id="year-2016">Year 2016</h4>
<div>
    <a href="https://plot.ly/~thechange/12/?share_key=FdkgfNh1YAlplnk3z4MbWE" target="_blank" title="MP16"><img src="https://plot.ly/~thechange/12.png?share_key=FdkgfNh1YAlplnk3z4MbWE" alt="MP16" width="600"></a>
    
</div>
<p>It’s clear from the plot that most counties record more recommits on Money bond than that in PR bond.</p>
<h2 id="felony-1">Felony</h2>
<blockquote>
<p>Let’s now look at a similar level of comparison for recommits when bailed out for Felony charges.</p>
</blockquote>
<h4 id="year-2014-1">Year 2014</h4>
<div>
    <a href="https://plot.ly/~thechange/32/?share_key=gbryVp83EPg1jS8JbHdXwm" target="_blank" title="FP14"><img src="https://plot.ly/~thechange/32.png?share_key=gbryVp83EPg1jS8JbHdXwm" alt="FP14" width="600"></a>
    
</div>
<h4 id="year-2015-1">Year 2015</h4>
<div>
    <a href="https://plot.ly/~thechange/34/?share_key=k9UtkDAB9lZJtd0wp9cF0l" target="_blank" title="FP15"><img src="https://plot.ly/~thechange/34.png?share_key=k9UtkDAB9lZJtd0wp9cF0l" alt="FP15" width="600"></a>
    
</div>
<h4 id="year-2016-1">Year 2016</h4>
<div>
    <a href="https://plot.ly/~thechange/36/?share_key=RmLIFK2ln1pScHmUBPCDRq" target="_blank" title="FP16"><img src="https://plot.ly/~thechange/36.png?share_key=RmLIFK2ln1pScHmUBPCDRq" alt="FP16" width="600"></a>
    
</div>
<p>Examining the crime recommit rates of people out on bond makes it clear that the system of money bail is set up so that it fails to keep the dangerous criminals while detaining those who cannot afford to pay the amount regardless of their innocence. In fact, the typical Black man, Black woman, and Hispanic woman detained for failure to pay a bail bond were living below the poverty line before incarceration.</p>
<p>The numbers most definitely makes us question the policy where the freedom of a criminal is not based on his innocence but by the amount of money he has in his pockets. Does the <strong>constitutional principle</strong> of <strong>innocent until proven guilty</strong> only really applies to the well off?</p>
<h2 id="how-does-poverty-determine-the-cash-bonds-posting">How does poverty determine the cash bonds posting</h2>
<p>Let’s take a sneak peek to how many people are given bail on cash bonds by comparing counties on the basis of their povert rate</p>
<div>
    <a href="https://plot.ly/~thechange/50/?share_key=uHQXYgJ6l46ceGIzpif8Z8" target="_blank" title="Poverty14"><img src="https://plot.ly/~thechange/50.png?share_key=uHQXYgJ6l46ceGIzpif8Z8" alt="Poverty14" width="600"></a>
    
</div>
<p>As can be seen from the chart, the counties with high poverty rate (&gt;30) have almost negligible amounts of money bond postings compared to the evr increasing numbers (&gt;5000) in counties with poverty rate less than 15. The data reveals just how unrealistic it is to expect defendants to be able to quickly patch together money for a bail bond when there are high chances that they don’t even touch the poverty line (and lie below it).</p>
<p>At a time like this, the system of justice stands questionable which seems to be inclined more towards the better earning!</p>
</div>
</body>

</html>
