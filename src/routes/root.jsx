import { Link } from "react-router-dom";
export default function Root() {
    return (
      <>
        <div id="sidebar">
          <h1>HOME</h1>
          <nav>
            <ul>
              <li>
                <Link to='user'>Users(1.2.1)</Link>
              </li>
              <li>
                <Link to='teacher'>Teacher(1.2.3)</Link>
              </li>
            </ul>
          </nav>
        </div>
        <div id="detail"></div>
      </>
    );
  }