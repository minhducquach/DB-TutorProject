import React, { useState } from "react";

const AddForm = ({ onUserInserted, closeModal }) => {
  const [user, setUser] = useState({
    Gender: "",
    FullName: "",
    Email: "",
    Street: "",
    City: "",
    Province: "",
    PhoneNumber: "",
    YearOfBirth: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUser((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch("http://localhost:3000/api/insertUser", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(user),
      });
      if (!response.ok) {
        throw new Error(response.statusText);
      }
      const data = await response.json();
      console.log("User inserted successfully:", data);
      onUserInserted(Date.now());
      closeModal(true);
    } catch (error) {
      console.error("An error occurred while inserting the user:", error);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <label>
        Gender:
        <select name="Gender" value={user.Gender} onChange={handleChange}>
          <option value="">Select...</option>
          <option value="M">Male</option>
          <option value="F">Female</option>
        </select>
      </label>
      <label>
        Full Name:
        <input
          type="text"
          name="FullName"
          value={user.FullName}
          onChange={handleChange}
        />
      </label>
      <label>
        Email:
        <input
          type="email"
          name="Email"
          value={user.Email}
          onChange={handleChange}
        />
      </label>
      <label>
        Street:
        <input
          type="text"
          name="Street"
          value={user.Street}
          onChange={handleChange}
        />
      </label>
      <label>
        City:
        <input
          type="text"
          name="City"
          value={user.City}
          onChange={handleChange}
        />
      </label>
      <label>
        Province:
        <input
          type="text"
          name="Province"
          value={user.Province}
          onChange={handleChange}
        />
      </label>
      <label>
        Phone Number:
        <input
          type="tel"
          name="PhoneNumber"
          value={user.PhoneNumber}
          onChange={handleChange}
        />
      </label>
      <label>
        Year of Birth:
        <select
          name="YearOfBirth"
          value={user.YearOfBirth}
          onChange={handleChange}
        >
          <option value="">Select...</option>
          {Array.from(
            { length: new Date().getFullYear() - 1899 },
            (_, i) => 1900 + i
          ).map((year) => (
            <option key={year} value={year}>
              {year}
            </option>
          ))}
        </select>
      </label>
      <input type="submit" value="Submit" />
    </form>
  );
};

export default AddForm;
