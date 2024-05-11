import React, { useState } from "react";
import "./ModalStyles.css";

const Modal = ({ show, children, onClose }) => {
  if (!show) {
    return null;
  }

  return (
    <div className="modal" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        {children}

        {/* <button onClick={onClose}>Close</button> */}
      </div>
    </div>
  );
};

export default Modal;
