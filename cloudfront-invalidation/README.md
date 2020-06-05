# cloudfront-invalidation

Intended to be used as a Kubernetes job that will wait for a deployment to finish and invalidate an AWS CloudFront cache.

## Usage

Set the following environment variables to customize behavior.

`SLEEP_INTERVAL`: number of seconds to sleep before watching the deployment.
`DEPLOYMENT`: the name of the deployment to watch in Kubernetes.
`CLOUDFRONT_DISTRIBUTION_ID`: the ID of the CloudFront distribution to invalidate.