import DataTable from "react-data-table-component";
import { useState, useEffect } from "react";
import Button from "./TeacherButton.jsx";
import { Link } from "react-router-dom";

function TApp() {
  const [data, setData] = useState([]);

  useEffect(() => {
    async function fetchAPI() {
      const response = await fetch("http://localhost:3000/allteacher", {
        method: "GET",
      });

      const responseJson = await response.json();
      setData(responseJson);
    }
    fetchAPI();
  }, []);

  const handleChangeCity = async (e) => {
    const selectedValue = e.target.value;
    const response = await fetch(
      `http://localhost:3000/allteacher/${selectedValue}`,
      {
        method: "GET",
      }
    );
    const res = await response.json();
    console.log(res);
    setData(res);
  };

  const columns = [
    {
      name: "UserID",
      selector: (row) => <Link to={`${row.UserID}`}>{row.UserID}</Link>,
    },
    {
      name: "FullName",
      selector: (row) => <div title={row.FullName}>{row.FullName}</div>,
    },
    {
      name: "Gender",
      selector: (row) => <div title={row.Gender}>{row.Gender}</div>,
    },
    {
      name: "CourseName",
      selector: (row) => <div title={row.CourseName}>{row.CourseName}</div>,
    },
    {
      name: "Description",
      selector: (row) => <div title={row.Description}>{row.Description}</div>,
    },
    {
      name: "Capacity",
      selector: (row) => <div title={row.Capacity}>{row.Capacity}</div>,
    },
  ];

  return (
    <div>
      <Button onChangeCity={handleChangeCity} />
      <DataTable
        columns={columns}
        data={data}
        pointerOnHover
        highlightOnHover
      />
    </div>
  );
}

export default TApp;
