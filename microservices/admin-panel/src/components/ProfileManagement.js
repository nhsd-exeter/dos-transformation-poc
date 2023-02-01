import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';


class ProfileManagement extends Component {

  render(){
    return (
      <Fragment>
        {!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }
        <div className="box cta">
          <p className="has-text-centered">
            <span className="tag is-primary">Profile Management</span> Profile services</p>
        </div>
      </Fragment>
    )
  }
}

export default ProfileManagement

