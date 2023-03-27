import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';
import axios from 'axios';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import AccordionDetails from '@mui/material/AccordionDetails';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';



class ServiceManagement extends Component {
  constructor () {
    super()
    this.state = { currentService: null }
  }

  componentDidMount() {
    this.getService()
      .then(result => this.setState({ currentService: result }) )
  }

  getService = async () =>
  {
    console.log( this.props.auth.user.token)
    const APIGateway = axios.create({
      baseURL: 'https://ar7kwintik.execute-api.eu-west-2.amazonaws.com/main/services',
      timeout: 3000,
      headers: {
        "Authorization": this.props.auth.user.token,
        "Access-Control-Allow-Origin": "https://localhost", 
        "Content-Type": "application/json"
      }
    });

    const {request} = await APIGateway.get();
    const parsedResponse= await JSON.parse(request.response);
    let service = await parsedResponse.body;

    return service;

  }

  render(){

    if(!this.state.currentService){return null}
    return (
      <Fragment>
        {!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }
        <div className="box cta">
          <p className="has-text-centered">
            <span className="tag is-primary">Service Management</span> Manage services</p>
        </div>
<div><h2>{this.state.currentService.name}</h2></div>
<div>

<TableContainer component={Paper}>
      <Table sx={{ minWidth: 500 }} aria-label="custom pagination table">
        <TableBody>
            <TableRow>
              <TableCell component="th" scope="row">
                <p>Name</p>
              </TableCell>
              <TableCell style={{ width: 160 }} align="right">
                {this.state.currentService.name}
              </TableCell>
              <TableCell style={{ width: 160 }} align="right">
                <p>Icon</p>
              </TableCell>
            </TableRow>
        </TableBody>
      </Table>
    </TableContainer>
</div>




        <div>
        <Accordion>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon />}
          aria-controls="panel1a-content"
          id="panel1a-header"
        >
          <Typography>Location</Typography>
        </AccordionSummary>
        <AccordionDetails>
          <Typography>
            <div>{this.state.currentService.name}</div>
          </Typography>
        </AccordionDetails>
        </Accordion>
        </div>
        <div>
        <Accordion>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon />}
          aria-controls="panel1a-content"
          id="panel1a-header"
        >
          <Typography>Provider Organisation</Typography>
        </AccordionSummary>
        <AccordionDetails>
          <Typography>
            <div>{this.state.currentService.name}</div>
          </Typography>
        </AccordionDetails>
        </Accordion>
        </div>
        <div>
        <Accordion>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon />}
          aria-controls="panel1a-content"
          id="panel1a-header"
        >
          <Typography>Coverage Area</Typography>
        </AccordionSummary>
        <AccordionDetails>
          <Typography>
            <div>{this.state.currentService.name}</div>
          </Typography>
        </AccordionDetails>
        </Accordion>
        </div>

      </Fragment>

    )
  }
}

export default ServiceManagement



