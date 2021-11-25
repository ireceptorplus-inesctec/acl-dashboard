# acl-dashboard

Access control dashboard for an easy and interactive management of user-based permissions on the [ADC Middleware](https://github.com/ireceptorplus-inesctec/adc-middleware)

Project runs on **Vue.js** using **keycloak-js** library to manage the authentication compatibility with the *middleware*

This project also uses the following main libraries: **axios**, **vue-router**, **vuedraggable**, **vuetify** and **vuex**

## Getting started

```bash
# clone the project
git clone https://github.com/ireceptorplus-inesctec/acl-dashboard

# enter the project directory
cd acl-dashboard

# install dependencies
npm install
```

## Run in development mode

```bash
# edit environment variables
nano .env
OR
nano .env.local

# run project in development mode
npm run serve
```

## Build and minify for production

```bash
# edit environment variables
nano .env
OR
nano .env.production

# build project
npm run build
```

Note the *.env.local* and *.env.production* override *.env*

## !!! Environment variables !!!

***FALAR DO .ENV***

## Features

- Owners
  - List pending requests
    - Accept/Deny pending requests
  - List owned resources
    - List users and scopes resource is shared with
    - Revoke access from another user to owner resource
  - Share (specific scope from a) resource with another user
  - Transfer resource ownership to another user
  - Update field mappings for each study
    - Create/Delete/Use templates

- All users
  - List resources shared with them

## Features (description)

- **Owners**
  - **List pending requests** - an owner can see a list of the pending requests sent by users to any of his owned resources
    - **Accept/Deny pending requests** - an owner can accept or deny any of the user made requests, granting access to a specific scope of a resource or denying it
  - **List owned resources** - an owner can list all the resources he owns together with the available access scopes for that resource
    - **List users and scopes resource is shared with** - an owner can access his resources details, listing all the users the resource is shared with and the corresponding scopes
    - **Revoke access from another user to owner resource** - an owner can revoke another user's access to his resources, clearing all the granted access scopes
  - **Share (specific scope from a) resource with another user** - an owner can share a resource with any user via username or email, selecting the wanted access scopes
  - **Transfer resource ownership to another user** - an owner can revoke the ownership of a resource by sharing it with any user via username or email, making the new user the new owner of the resource
  - **Update field mappings for each study** - an owner can configure which study fields are shared with each scope, customizing how the study is shared with the remaining users
    - **Create/Delete/Use templates** - an owner can utilize templates to avoid recreating and reutilize field mapping schemes, being able to create and delete them as well

- **All users**
  - **List resources shared with them** - a user can list all the resources that are shared with him, viewing the access scopes he was granted for each resource

## Browsers support

Modern browsers and Internet Explorer 11+

| [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/edge/edge_48x48.png" alt="IE / Edge" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br/>IE / Edge | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/firefox/firefox_48x48.png" alt="Firefox" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br/>Firefox | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/chrome/chrome_48x48.png" alt="Chrome" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br/>Chrome | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/safari/safari_48x48.png" alt="Safari" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br/>Safari |
| --------- | --------- | --------- | --------- |
| IE11, Edge| last 2 versions| last 2 versions| last 2 versions

## ??? License ???