# SPIKE: WAF Bot Control

## Bottom Line Up Front

If you want to block requests with "weird" UserAgents, WAF Bot Control might be useful to you.  If you aren't using WAF at all, you should start using other rules first.  If you're hoping to cut down on bot spam that gets through your standard set of WAF rules... this might not be too helpful.

$10/mo is a low enough price, but if it's not blocking additional traffic, it's not worth it.

## Overview

Bot traffic is generally considered part of the "Internet Background Radiation".  It's ever-present, unrelenting, and high volume.  It can impose real costs on infrastructure in the form of increased server/container counts to manage extra traffic for non-humans.  Unfortunately, it's very difficult to avoid.

WAF Bot Control is a WAFv2 Managed Ruleset that attempts to mitigate some of this traffic.  The ruleset is managed by WAF experts within AWS, and costs $10/mo for each WAF that uses it.  

The exact functionality of it is obfuscated, so if you get a legitimate request unexpectedly blocked, you might not be able to determine why, or how to fix it.  When requests are blocked, it will log the rule that tripped ("CategoryHttpLibrary", "SignalNonBrowserUserAgent", etc), but that's pretty much as far as it goes.

## Test Usage

In testing Bot Control, I created a Fargate service with an ALB, attaching a Regional WAF to it, with BotControl enabled, just to see what would happen.

The first thing I noticed was curl/httpie no longer worked.  They were tripping the rule for `SignalNonBrowserUserAgent`.  I copied the UserAgent from my browser, and set the header in httpie, and the connection went through immediately.  It seems that even a simple attempt to present myself as a "real browser user" got past the RuleSet

After leaving the WAF/Service up and running for a while, I checked the logs to see what kind of requests made it through to the service.  The WAF included many of the "standard" AWS WAF Rules, including CommonRuleset and SQLInjection prevention.  These were some of the requests that did _not_ get halted by any of the rules:
* Obvious Bot UserAgents:
  * `masscan/1.0 (https://github.com/robertdavidgraham/masscan)`
  * `masscan/1.3 (https://github.com/robertdavidgraham/masscan)`
  * `Mozilla/5.0 (compatible; Nimbostratus-Bot/v1.3.2; http://cloudsystemnetworks.com)`
* Malicious Requests (that slipped through the CommonRuleset):
  * `GET /.env HTTP/1.1`
  * `POST / HTTP/1.1`
  * `GET ../../proc/ HTTP`
  * `GET /index.php HTTP/1.1`
  * `GET /elrekt.php HTTP/1.1`

## WAF Log Labels

When an incoming request matches a sub-rule on the BotControl managed rule, even if the rule is disabled/COUNT-only, it will add a tag to the Logs to indicate which sub-rule matched.  This makes it easy to troubleshoot requests when you expected them to go through, but they get blocked.  Also it can let you know in what ways you might want to tweak the rule config.

Examples inclue:
* `[{name=awswaf:managed:aws:bot-control:bot:category:http_library}, {name=awswaf:managed:aws:bot-control:bot:name:python}, {name=awswaf:managed:aws:bot-control:bot:name:python_requests}, {name=awswaf:managed:aws:bot-control:signal:non_browser_user_agent}]`
* `[{name=awswaf:managed:aws:bot-control:signal:non_browser_user_agent}]` (most common, by far)
* `[{name=awswaf:managed:aws:bot-control:signal:known_bot_data_center}, {name=awswaf:managed:aws:bot-control:signal:non_browser_user_agent}]`

## Summary

* Ignores popular search engines (google/bing) by default
* Part of the standard WAFv2 API
* Also has its own dashboard to view block/count types
* $10/mo per WAF that uses it
* Appears to function best on "honest" bots that aren't trying to hide the fact that they're bots

## Links

* [AWS What's New Blog](https://aws.amazon.com/about-aws/whats-new/2021/04/announcing-aws-waf-bot-control/)
* [AWS Product Page](https://aws.amazon.com/waf/features/bot-control/)
