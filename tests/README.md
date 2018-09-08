# Templates testing envorinment

## Testing tool
As a testin tool we choose  
https://github.com/pester/Pester/wiki/Pester

## Tree structure
| Folder | Description
|-|-|
| structure | Template structure validation tests. These tests will go thru the template structure without actually deploying it which allows fast initial testing level |
| deployment | Deployment validation tests. These tests involves actual deployment hence require access to AWS account |

## Running tests
```
cd tests
Invoke-Pester -Script @{ Path = '<test folder>'; Parameters = @{ randomNumber = '<execution number>' }; }