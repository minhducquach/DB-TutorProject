import React, { useState } from "react";
import "./ButtonStyles.css";
import AddForm from "./AddForm";
import Modal from "./Modal";

const Button = ({ onDeleteModeChange, onUpdateModeChange, onUserInserted }) => {
  const [showModal, setShowModal] = useState(false);
  const [isDeleteMode, setIsDeleteMode] = useState(false);
  const [isUpdateMode, setIsUpdateMode] = useState(false);

  const handleAddClick = () => {
    setShowModal(true);
  };

  const handleAddClose = () => {
    setShowModal(false);
  };

  const handleDeleteClick = () => {
    if (isUpdateMode) {
      setIsUpdateMode(!isUpdateMode);
      onUpdateModeChange(!isUpdateMode);
    }
    setIsDeleteMode(!isDeleteMode);
    onDeleteModeChange(!isDeleteMode);
  };

  const handleUpdateClick = () => {
    if (isDeleteMode) {
      setIsDeleteMode(!isDeleteMode);
      onDeleteModeChange(!isDeleteMode);
    }
    setIsUpdateMode(!isUpdateMode);
    onUpdateModeChange(!isUpdateMode);
  };

  return (
    <div className="parent">
      <button onClick={handleAddClick} className="my-button rounded-button">
        Thêm
      </button>
      <Modal show={showModal} onClose={handleAddClose}>
        <AddForm onUserInserted={onUserInserted} closeModal={handleAddClose} />
      </Modal>
      <button onClick={handleDeleteClick} className="my-button rounded-button">
        Xóa
      </button>
      <button onClick={handleUpdateClick} className="my-button rounded-button">
        Sửa
      </button>
      
    </div>
  );
};

export default Button;
