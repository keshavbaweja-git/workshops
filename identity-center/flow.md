```mermaid
sequenceDiagram
    participant eidp as External IdP
    actor user as User
    participant idc as AWS Identity Center
    participant account as AWS Account
    participant sts as AWS Security Token Service
    autonumber
    user->>idc: User browses to IDC Start URL
    idc->>idc: Generates SAML request
    idc->>user: Redirects response
    user->>eidp: Browser relays request
```