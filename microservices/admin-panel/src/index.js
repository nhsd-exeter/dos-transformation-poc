import React from 'react';
import ReactDOM from 'react-dom/client';
import 'bulma/css/bulma.min.css';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';
import { Amplify } from 'aws-amplify';

//TODO - IDEALLY THIS DATA SHOULD BE ABSTRACTED AWAY INTO A GITHUB SECRETS STORE.
//THESE ARE NOT SENSITIVE AS THEY RETURN ON THE USER OBJECT, BUT SHOULD NOT REALLY BE HARD CODED.
Amplify.configure({
    Auth: {
        mandatorySignId: true,
        region: "eu-west-2",
        userPoolId: "eu-west-2_KPwuBPgHI",
        userPoolWebClientId: "18csisad7okih7mdovl0fmhcl7"
    }
})

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />)

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister();
