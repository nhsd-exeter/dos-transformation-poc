
import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';
import Hero from './Hero';
import HomeContent from './HomeContent';


class Home extends Component {

  render(){
    console.log()
    return (
      <Fragment>
        {!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }
        <Hero />
        <div className="box cta">
          <p className="has-text-centered">
            <span className="tag is-primary">New</span> A temporary placeholder page for the new DoS adminstrator panel. </p>
        </div>
        <HomeContent />
      </Fragment>
    )
  }

}

export default Home