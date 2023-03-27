import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';
import axios from 'axios';


class ServiceManagement extends Component {

  getService = async () =>
  {
    console.log( this.props.auth.user.token)
    const APIGateway = axios.create({
      baseURL: 'https://ar7kwintik.execute-api.eu-west-2.amazonaws.com/main/services?id=1233123',
      timeout: 1000,
      headers: {
        "Authorization": this.props.auth.user.token,
        "Access-Control-Allow-Origin": "https://localhost", 
        "Content-Type": "application/json"
      }
    });

    const {service} = await APIGateway.get();
    
  }

  render(){
    console.log(this.props)

    this.getService();


    return (
      <Fragment>
        {!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }
        <div className="box cta">
          <p className="has-text-centered">
            <span className="tag is-primary">Service Management</span> Manage services</p>
        </div>
      </Fragment>
    )
  }
}

export default ServiceManagement

