# Cognito & PGAdmin

# Intro

In this spike we wanted to see how Cognito is used to provide robust authentication when attempting
to connect to a PGAdmin service running in Fargate that sits behind an Application Load-balancer (ALB) thus
providing a mechinisim to query internal databases without the need for a Virtual Private Network (VPN).


1. Isolated a VPC with both public and private subnets
2. Created a basic Cognito user pool, client and domain in which authentication can be provided
3. Deployed the ALB in a public subnet
4. Added listeners and rules to the ALB with an http-to-https redirect and https forward to a target group once Congitio provides authentication
5. Deployed the PGAdmin as a Fargate service that registered with the target group
6. Provisioned a t3.micro RDS posgres-12 instance in the private subnet so that we have database to connect with


# Conclusion

If your only need for a VPN is to connect to a database, then this works beautifully!


## Reference Docs
* https://transcend.io/blog/restrict-access-to-internal-websites-with-beyondcorp
