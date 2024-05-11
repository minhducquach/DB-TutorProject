import "mdb-react-ui-kit/dist/css/mdb.min.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import React from "react";
import ReactDOM from "react-dom/client";
import Profile from "./Profile";
import Root from "./routes/root";
import ErrorPage from "./error-page";
import App from "./App";
import Teacher from "./Teacher";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import "./index.css";
const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
  },
  {
    path: "user",
    element: <App />,
  },
  {
    path: "",
    element: <Teacher />,
  },
  {
    path: "teacher/:id",
    element: <Profile />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
