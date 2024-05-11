import { useState, useEffect } from "react";
import "./ButtonStyles.css";

const Button = ({ onChangeCity }) => {
  const [course, setCourse] = useState([]);

  useEffect(() => {
    async function fetchAPI() {
      const response = await fetch("http://localhost:3000/allcourses", {
        method: "GET",
      });

      const responseJson = await response.json();
      console.log(responseJson);
      setCourse(responseJson);
    }
    fetchAPI();
  }, []);

  const handleSelect = (e) => {
    onChangeCity(e);
  };

  return (
    <div className="parent">
      <div>
        <select
          name="city"
          className="my-button rounded-button"
          onChange={handleSelect}
        >
          <option value="">Tất cả khóa học</option>
          {course.map((cs, i) => (
            <option key={i} value={cs.CourseID}>
              {cs.CourseName}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
};

export default Button;
