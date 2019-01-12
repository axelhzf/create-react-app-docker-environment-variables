# create-react-app-docker-environment-variables

`create-react-app` has a whole [section](https://facebook.github.io/create-react-app/docs/adding-custom-environment-variables) about how to work with environment variables. The used approach is to replace the environment variables at build time. So the generated assets (.js, .html) already have the variables replaced.

The problem with this approach is that you need to rebuild the whole application every time you want to assign a different value to a variable. 

This is an example of how to use environment variables at **runtime** assuming that you are using docker to deploy your application. The main benefit of this approach is that you are going to be able to use the same image in multiple environments.

### Try it

Build the docker image 

```
docker build --tag cra-docker-env .
```

Run the image passing some environment variables prefixed with `REACT_APP_`

```
docker run \
    -e REACT_APP_API='http://api.com' \
    -e REACT_APP_TOKEN='123' \
    -p8080:80 \
    cra-docker-env  
```

Every environment variable prefixed with `REACT_APP_` will be available in `window.ENV`.

Open `http://localhost:8000`. You will see the list of you environment variables.

### How does this works?

The `index.html` contains the code the initialize the `window.ENV` variable

```html
<script>
  var ENV = %REACT_APP_ENV%;
</script>
```

The `%REACT_APP_ENV%` will be replaced at runtime by the `docker-entrypoint.sh` file.
