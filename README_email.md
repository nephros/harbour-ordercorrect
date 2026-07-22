### Email content description

#### Example text:

```
Subject: JollaPhoneOrderChanges|#90210|address-change| My Delivery address

```

The Subject contains the fixed "email tag" `JollaPhoneOrderChanges`, followed
by order number and a category, separated by pipes, and finally the (optional)
user-supplied sunject text.

```
Ahoy Sailors!

[... user message ...]


Thank you,
  Kevin Freibeuter

  ~~~~ please do not edit anything below this line ~~~~
  ------------------
  Name: .... Kevin Freibeuter
  Email: ... evilkid1763@bucaneers.example.org
  Order: ... 90210
  ------------------
  Ref: ..... 5e46479b08232b849d474cade71d1a76
  Stamp: ... 1784622363
  Sequence:. 0
  ------------------
  Created by: OrderMail 0.1.3
  ------------------
```

The email body has a greeting, the user-supplied message, and a closing signature.

Below that, order details are repeated.

Finally, the following fields are added:

  - Ref: this is simply the MD5 hash of order number and email address. It is supposed to ease searching for mails.
  - Stamp: the UNIX timestamp of the message
  - Sequence: An integer showing the count of emails that have been sent from the same (device) user. This is supposed to identify email 'spam' - but of course the user is free to edit this.
  - Created by: The version string of the OrderMail app this email was created with.
