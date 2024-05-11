import DataTable from "react-data-table-component";
import React, { useState, useEffect } from "react";
import Button from "./Button.jsx";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faEdit } from "@fortawesome/free-solid-svg-icons";
import Modal from "./Modal.jsx";
import UpdateForm from "./UpdateForm.jsx";

function App() {
  const [data, setData] = useState([]);
  const [isDeleteMode, setIsDeleteMode] = useState(false);
  const [isUpdateMode, setIsUpdateMode] = useState(false);
  const [selectedRows, setSelectedRows] = useState([]);
  const [showUpdateModal, setShowUpdateModal] = useState(false);
  const [lastUpdated, setLastUpdated] = useState(Date.now());
  const [lastInserted, setLastInserted] = useState(Date.now());

  useEffect(() => {
    async function fetchAPI() {
      const response = await fetch("http://localhost:3000/api/getAllUsers", {
        method: "GET",
      });

      const responseJson = await response.json();
      console.log(responseJson);
      setData(responseJson);
      setSelectedRows([]);
    }
    fetchAPI();
  }, [lastUpdated, lastInserted]);

  const handleRowClick = (row, event) => {
    const isChecked = event.target.checked;
    if (isChecked) {
      setSelectedRows([...selectedRows, row]);
    } else {
      setSelectedRows(selectedRows.filter((item) => item !== row));
    }
  };

  const handleUpdateModalClose = () => {
    setShowUpdateModal(false);
  };

  const handleDeleteModeChange = (deleteMode) => {
    // console.log("DELETE CLICKED");
    setIsDeleteMode(deleteMode);
    setSelectedRows([]);
  };

  const handleUpdateModeChange = (updateMode) => {
    console.log("UPDATE CLICKED");
    setIsUpdateMode(updateMode);
    setSelectedRows([]);
  };

  const handleDeleteClick = async () => {
    if (selectedRows.length > 0) {
      for (let row of selectedRows) {
        try {
          await fetch("http://localhost:3000/api/deleteUser", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(row),
          });
          console.log(`User ${row.UserID} deleted successfully`);
        } catch (error) {
          console.error(
            `An error occurred while deleting user ${row.UserID}:`,
            error
          );
        }
      }
      setLastUpdated(Date.now());
      setSelectedRows([]);
    }
  };

  const handleUpdateClick = () => {
    if (selectedRows != []) {
      setShowUpdateModal(true);
    }
  };

  const columns = [
    {
      name: "UserID",
      selector: (row) => row.UserID,
    },
    {
      name: "FullName",
      selector: (row) => <div title={row.FullName}>{row.FullName}</div>,
    },
    {
      name: "Email",
      selector: (row) => <div title={row.Email}>{row.Email}</div>,
    },
    {
      name: "PhoneNumber",
      selector: (row) => <div title={row.PhoneNumber}>{row.PhoneNumber}</div>,
    },
    {
      name: "Gender",
      selector: (row) => <div title={row.Gender}>{row.Gender}</div>,
    },
    {
      name: "YearOfBirth",
      selector: (row) => <div title={row.YearOfBirth}>{row.YearOfBirth}</div>,
    },
    {
      name: "Street",
      selector: (row) => <div title={row.Street}>{row.Street}</div>,
    },
    {
      name: "City",
      selector: (row) => <div title={row.City}>{row.City}</div>,
    },
    {
      name: "Province",
      selector: (row) => <div title={row.Province}>{row.Province}</div>,
    },
    ...(isDeleteMode
      ? [
          {
            name: (
              <FontAwesomeIcon icon={faTrash} onClick={handleDeleteClick} />
            ),
            cell: (row) => (
              <input
                type="checkbox"
                className="checkbox"
                checked={selectedRows.includes(row) ? true : false}
                onChange={(e) => handleRowClick(row, e)}
              />
            ),
            ignoreRowClick: true,
            button: "true",
            width: "50px",
          },
        ]
      : isUpdateMode
      ? [
          {
            name: <FontAwesomeIcon icon={faEdit} onClick={handleUpdateClick} />,
            cell: (row) => (
              <input
                type="checkbox"
                className="checkbox"
                disabled={
                  isUpdateMode &&
                  selectedRows.length > 0 &&
                  !selectedRows.includes(row)
                }
                checked={selectedRows.includes(row) ? true : false}
                onChange={(e) => handleRowClick(row, e)}
              />
            ),
            ignoreRowClick: true,
            button: "true",
            width: "50px",
          },
        ]
      : []),
  ];

  return (
    <div>
      <Button
        onDeleteModeChange={handleDeleteModeChange}
        onUpdateModeChange={handleUpdateModeChange}
        onUserInserted={setLastInserted}
      />
      <DataTable
        columns={columns}
        data={data}
        onRowClicked={handleRowClick}
        pointerOnHover
        highlightOnHover
      />
      <Modal show={showUpdateModal} onClose={handleUpdateModalClose}>
        <UpdateForm
          selectedRow={selectedRows[0]}
          onUserUpdated={setLastUpdated}
          closeModal={handleUpdateModalClose}
        />
      </Modal>
    </div>
  );
}

export default App;
