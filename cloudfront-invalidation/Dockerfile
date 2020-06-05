FROM debian:jessie

# Install dependencies needed to install packages
RUN apt-get update -y && apt-get install -y curl unzip

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# helpful with debugging if we ever need it
RUN kubectl version --client
RUN aws --version

# Sleep for a few seconds to give Kubernetes time to get the deployment going.
# Then wait for the deployment to finish and invalidate cloudfront
CMD [ \
  "/bin/sh", \
  "-c", \
  "sleep $SLEEP_INTERVAL", \
  "&&", \
  "kubectl rollout status deployment $DEPLOYMENT", \
  "&&", \
  "aws" \
  "cloudfront", \
  "create-invalidation", \
  "--distribution-id", \
  "$CLOUDFRONT_DISTRIBUTION_ID", \
  "--paths", \
  "/*", \
  ]
