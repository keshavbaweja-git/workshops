```mermaid
sequenceDiagram
    participant eidp as External IdP
    actor user as External User
    participant idc as AWS Identity Center
    participant account as AWS Account
    participant sts as AWS Security Token Service
    autonumber

    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!

```