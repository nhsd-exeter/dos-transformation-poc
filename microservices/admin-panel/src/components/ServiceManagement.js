import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';
import axios from 'axios';


class ServiceManagement extends Component {

  getService = async (id) =>
  {
    const APIGateway = axios.create({
      baseURL: 'https://ar7kwintik.execute-api.eu-west-2.amazonaws.com/main/services',
      timeout: 1000,
      headers: {
        'Authorization': this.props.auth.token,
        "Access-Control-Allow-Origin": "*", 
        'Access-Control-Allow-Methods': 'POST, PUT, GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With'
      }
    });

    const {service} = await APIGateway.get('id');
    
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

