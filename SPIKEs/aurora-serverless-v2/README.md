# AWS Aurora Serverless v2

## Bottom Line Up Front

The value comes from two places:  Autopause, and Fast Scale up.
* You can set the "autopause" time as low as 5 minutes.  After 5 minutes with no queries, the database will shutdown, saving money
* You can set fairly high maximum for CPU scaling, and it will only use that when performance demands.  This saves you money by not having to provision a big database for peak production demands

On the low-end of pricing:
* If your application uses your database whenever it's running, the low-end of scaling will be eaten up by application uptime
* If your app hits the database more than a few hours a day, you will have a hard time beating the price of a db.t3.small you power up for 12 hours/weekday.

On the high-end of pricing:
* This is where Serverless v2 really shines.  Fast scale-up/down means your application can save good money on the top-end without relying on reserved capacity or a high minimally scaleable unit (`db.*.xlarge`, etc.)

## Costs

For calculation, 1 month is considered 720 hours.

* Running costs depend on usage:
  * Minimum cost of running minimum of 1 cpu: $86.4/mo +storage; AWS rep claims you can provision a minimum of 0.5 CPU ($24), but I could not replicate with the API+Terraform.
  * Minimum cost of running minimum of 0 CPU: $0/mo + storage + $0.12/hr; this can result in to a 1-2 minute delay in access for bootup
  * Cost of running a production-ready system capabale of handling load:  Hard to say, but should target exactly what you need without thinking about it

* Costs to run an Aurora MySQL db.t3.small 24/7: $29
  * Breakeven "on-time": 8 hours/day.  If Aurora Serverless is on less than this, you save money
* Costs to run an Aurora MySQL db.t3.small 12/5: $10.35
  * Breakeven "on-time": 2.87 hours/day.  If Aurora Serverless is on less than this, you save money
  * Breakeven Weekday "on-time": 4.02 hours/day.  If Aurora serverless is off all weekend, and on during weekdays more than this, you save money
* Costs to run a MySQL 1-year Reserved Instance db.t3.small 24/7: $19.55
  * Breakeven "off-time": 5.43 hours/day.  If Aurora Serverless is off more than this, you save money

## Considerations

Currently in Preview, meaning each account you use this on will need to be enabled.  Not that big of a deal, but sometimes preview periods can take a while to end.

If you have high demand requirements of your dev environments, you might need to set a long shutdown period.

Your app will need to be configured to be fault tolerant for a database that fails to connect for 2 minutes.  Arguably, this is something you should have anyway.

Applications that "check in" with the database periodically (wordpress has a cron feature, for example) could prevent shutting down.

Cost from v1 ($0.06/hr/CPU) to v2 ($0.12/hr/CPU) is double, but v2 has steps in half-CPU increments.

## Reference Links

* [Announcement Page]()
* [Product Page]()
* [Best Practices](https://aws.amazon.com/blogs/database/best-practices-for-working-with-amazon-aurora-serverless/)
