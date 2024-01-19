

**Purpose:**

This Terraform configuration deploys a publicly accessible S3 bucket to host a static website.

**Key Components:**

- **Terraform:** Infrastructure as code tool for managing cloud resources.
- **AWS S3:** Object storage service used for hosting the website.

**Resources Created:**

- **S3 Bucket:** Primary storage for website content.
- **Bucket Ownership Controls:** Sets object ownership to "ObjectWriter".
- **Public Access Block:** Allows public access to bucket contents.
- **Bucket ACL:** Grants public read access.
- **Bucket Policy:** Explicitly allows public object retrieval.
- **Website Configuration:** Enables website hosting and sets the index document.
- **S3 Objects:** Uploads website files from the web directory.

**Prerequisites:**

- Terraform installed and configured.
- AWS credentials with necessary permissions.

**Usage:**

```bash
git clone <https://github.com/shefeekar/terraform-s3-bucket.git>
cd terraform-s3-bucket
```

**Set Variables:**

Update **`aws_region`** and **`bucket_name`** in the configuration file.

**Initialize:**

Run **`terraform init`** to initialize Terraform.

**Plan:**

Run **`terraform plan`** to preview changes.

**Apply:**

Run **`terraform apply`** to deploy the resources.

**Accessing the Website:**

The website will be accessible at http://<bucket-name>.s3-website.<aws-region>.amazonaws.com.

**Clean Up:**

To destroy the created resources, run:

```

terraform destroy

```
