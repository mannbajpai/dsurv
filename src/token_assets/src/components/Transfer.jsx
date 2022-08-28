import React, { useState } from "react";
import {token} from "../../../declarations/token";
import { Principal } from "@dfinity/principal";

function Transfer() {

  const [feedback, setFeedback] = useState("");
  const [isHidden,setHidden] = useState(true);
  const [isDisabled, setDisabled] = useState(false);
  const [inputPrincipal, setInputPrincipal] = useState("");
  const [inputAmont, setInputAmount] = useState("");
  
  async function handleClick() {
    setDisabled(true);
    setHidden(true);
    const toPId = Principal.fromText(inputPrincipal);
    const toAmt = Number(inputAmont);
    const feed = await token.transfer(toPId, toAmt);
    setFeedback(feed);
    setHidden(false);
    setDisabled(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={inputPrincipal}
                onChange = { (e) => setInputPrincipal(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={inputAmont}
                onChange = { (e) => setInputAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button 
          id="btn-transfer" 
          onClick={handleClick}
          disabled={isDisabled} >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}> {feedback} </p>
      </div>
    </div>
  );
}

export default Transfer;
