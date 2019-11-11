import React, { Component } from 'react';
// import Cookies from 'universal-cookie';

class Main extends Component {

  uuidv4() {
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    );
  }


  addUUIDtoDB(uuid, user) {
    // const cookies = new Cookies();
    // create a new XMLHttpRequest
    var xhr = new XMLHttpRequest()

    // get a callback when the server responds
    xhr.addEventListener('load', () => {
      // update the state of the component with the result here
      console.log(xhr.responseText)
    })
    // open the request with the verb and the url
    xhr.open('POST', 'http://localhost:5000/addUUID/' + uuid)
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    // send the request
    // console.log("User cookie: " + cookies.get("user"))
    xhr.send("user=" + user)
  }

  render() {
    return (
      <div id="content">
        <h1>Add Luggage</h1>
        <form onSubmit={(event) => {
            const weight = this.luggageWeight.value
            const airport_initial = this.luggageAirport.value
            const user = this.user.value
            const uuid = this.uuidv4()
            this.addUUIDtoDB(uuid, user)
            this.props.addLuggage(uuid, weight, airport_initial)
        }}>
          <div className="form-group mr-sm-2">
            <input
              id="username"
              type="text"
              ref={(input) => { this.user = input }}
              className="form-control"
              placeholder="Username"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageWeight"
              type="text"
              ref={(input) => { this.luggageWeight = input }}
              className="form-control"
              placeholder="Luggage Weight"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageAirport"
              type="text"
              ref={(input) => { this.luggageAirport = input }}
              className="form-control"
              placeholder="Luggage initial airport"
              required />
          </div>
          <button type="submit" className="btn btn-primary">Add Luggage</button>
        </form>
        <p>{ this.props.add_msg }</p>
        <br />
        <h1>Send Luggage</h1>
        <form>
          <div className="form-group mr-sm-2">
            <input
              id="luggageUUID_send"
              type="text"
              ref={(input) => { this.luggageUUID_send = input }}
              className="form-control"
              placeholder="Luggage UUID"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageAirportFrom_send"
              type="text"
              ref={(input) => { this.luggageAirportFrom_send = input }}
              className="form-control"
              placeholder="Luggage Source Airport"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageAirportTo_send"
              type="text"
              ref={(input) => { this.luggageAirportTo_send = input }}
              className="form-control"
              placeholder="Luggage Destination Airport"
              required />
          </div>
          <button type="button" className="btn btn-primary" onClick={(event) => {
            const uuid = this.luggageUUID_send.value
            const airport_from = this.luggageAirportFrom_send.value
            const airport_to = this.luggageAirportTo_send.value
            console.log(uuid)
            fetch('http://localhost:5000/getUUID/' + uuid)
            .then((response) => { return response.text() }) // change to return response.text()
            .then((text) => {
                console.log(text, text == "true\n")
                if (text == "true\n") {
                    this.props.sendLuggage(airport_from, airport_to, uuid)
                }
            })
        }}>Send Luggage</button>
        </form>
        <p>{ this.props.send_msg }</p>

        <br />
        <h1>Receive Luggage</h1>
        <form>
          <div className="form-group mr-sm-2">
            <input
              id="luggageUUID_receive"
              type="text"
              ref={(input) => { this.luggageUUID_receive = input }}
              className="form-control"
              placeholder="Luggage UUID"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageAirportFrom_receive"
              type="text"
              ref={(input) => { this.luggageAirportFrom_receive = input }}
              className="form-control"
              placeholder="Luggage Source Airport"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="luggageAirportTo_receive"
              type="text"
              ref={(input) => { this.luggageAirportTo_receive = input }}
              className="form-control"
              placeholder="Luggage Destination Airport"
              required />
          </div>
          <button type="button" className="btn btn-primary" onClick={(event) => {
            const uuid = this.luggageUUID_receive.value
            const airport_from = this.luggageAirportFrom_receive.value
            const airport_to = this.luggageAirportTo_receive.value
            console.log(uuid)
            // console.log("UUID exist: ", this.doesUUIDexist(uuid))
            // if(this.doesUUIDexist(uuid)) {
            //     this.props.sendLuggage(airport_from, airport_to, uuid)
            // }
            fetch('http://localhost:5000/getUUID/' + uuid)
            .then((response) => { return response.text() }) // change to return response.text()
            .then((text) => {
                console.log(text, text == "true\n")
                if (text == "true\n") {
                    this.props.receiveLuggage(airport_from, airport_to, uuid)
                }
            })
        }}>Receive Luggage</button>
        </form>
        <p>{ this.props.receive_msg }</p>

        <p> </p>
        <h2>All Luggages</h2>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">UUID</th>
              <th scope="col">Weight</th>
              <th scope="col">Initial Airport</th>
              {/* <th scope="col"></th> */}
            </tr>
          </thead>
          <tbody id="luggageList">
                { this.props.luggages.map((luggage, key) => {
                    return(
                        <tr key={key}>
                            <th scope="row">{key}</th>
                            <td>{luggage.uuid}</td>
                            <td>{luggage.weight}</td>
                            <td>{luggage.airport_initial}</td>
                            {/* <td><button className="buyButton">Buy</button></td> */}
                        </tr>
                    )
                })}
              
          </tbody>
        </table>
      </div>
    );
  }
}

export default Main;