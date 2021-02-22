# Set Node.js version in Azure Functions (test lab)

Full blog post [here](https://www.maxivanov.io/change-nodejs-version-in-azure-functions/).

There's a dev container for VS Code included to start quickly.

Create 4 function apps:

- Linux Premium
- Linux Consumption
- Windows Premium
- Windows Consumption

```bash
cd terraform

terraform init

terraform apply
```

Publish the version printer function to the function apps:

```bash
func azure functionapp publish <function app name linux premium>
func azure functionapp publish <function app name linux consumption>
...
```

Check Azure Functions runtime version:

```
curl -sS 'https://<function app name>.azurewebsites.net/admin/host/status?code=<master key>' | jq
```

Check Node.js version:

```bash
curl https://<function app name>.azurewebsites.net/api/hello-world
```

