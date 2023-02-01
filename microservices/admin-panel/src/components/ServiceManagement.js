import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';


class ServiceManagement extends Component {

  render(){
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

