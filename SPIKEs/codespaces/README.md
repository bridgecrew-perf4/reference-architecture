# Codespaces
GitHub [Codespaces](https://github.com/features/codespaces) is an offering that allows developers to spin up a cloud developer environment via GitHub itself.  This uses Visual Studio Code and offers two ways of working:

1. Using the in-browser editor, which is eerily similar to Visual Studio Code
2. Connecting to the remote environment using an actual local Visual Studio Code and the Remote Coding Extension


## Problem
The agency struggles to support software developers, because there's little support for segmenting them on the secure network and providing them the tools they need to be productive.  This is mostly a result of dated thinking around security, but change is hard in large organizations.  It may never be possible for a developer to receive local administrator rights (what they really need) on their computer, so they can install the software they need on demand.

## Opportunity
Products like Codespaces might bridge the gap between security requirements and developer productivity needs, because they allow ephemeral environments to be spun up on demand, which are low-risk to the organization because they are naturally segmented (they live in "the cloud"), but also give the user full access to go fast and be productive, because each workspace is fully featured.

## Questions
- Can you use Codespaces as a replacement for a local development machine?
- What is the performance like and is there latency in the experience?
- What other things are worth knowing about Codespaces?
- 
## Pricing
Here's a breakdown of pricing with comparisons to similar services as seen on 08/25/21.

### Compute
All estimates are for Linux virtual machines at on-demand pricing.

| Product          | Size   | Unit   | Price   | Yearly* |
| ---------------- | ------ | ------ | ------- | ------- |
| Azure B2MS       | 2 core | 1 hour | $0.0832 | $125    |
| Azure B4MS       | 4 core | 1 hour | $0.166  | $249    |
| Cloud9 T3.Medium | 2 core | 1 hour | $0.056  | $84     |
| Cloud9 T3.XLarge | 4 core | 1 hour | $0.224  | $336    |
| Codespaces       | 2 core | 1 hour | $0.18   | $270    |
| Codespaces       | 4 core | 1 hour | $0.36   | $540    |


*Yearly assumes developer is spending 1500 hours (6 hours/work day) in the environment

### Storage
This is an imperfect table, because Azure Disk is priced in 4 GB units, Cloud9 kind-of wraps EBS prices, and Codespaces is flat.  We're not exactly comparing apples-to-apples here, and everyone should be aware of that

| Product    | Size | Unit    | Price | Yearly   |
| ---------- | ---- | ------- | ----- | -------- |
| Azure Disk | 1 GB | 1 month | $0.15 | $1.80/GB |
| AWS Cloud9 | 1 GB | 1 month | $0.10 | $1.20/GB |
| AWS EBS    | 1 GB | 1 month | $0.15 | $1.80/GB |
| Codespaces | 1 GB | 1 month | $0.07 | $0.84/GB |

For reference and to see current prices: 

- [Codespaces](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/about-billing-for-codespaces#codespaces-pricing)
- [Cloud9](https://aws.amazon.com/cloud9/pricing/)
- [Azure VM](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/)
- [AWS EC2](https://calculator.aws/#/createCalculator/EC2)