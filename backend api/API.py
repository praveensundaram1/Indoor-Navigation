from collections import deque
from flask import Flask, request, jsonify, send_file
import json
import numpy as np
import math
import heapq
import matplotlib
import matplotlib.pyplot as plt
import sqlite3

app = Flask(__name__)
matplotlib.use('Agg')

def initialize_database():
    conn = sqlite3.connect('buildings.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS buildings
                 (name TEXT PRIMARY KEY, walls_data TEXT, doors_data TEXT)''')
    conn.commit()
    conn.close()

initialize_database()

def add_building_to_database(name, walls_data, doors_data):
    conn = sqlite3.connect('buildings.db')
    c = conn.cursor()
    c.execute("INSERT INTO buildings (name, walls_data, doors_data) VALUES (?, ?, ?)", (name, json.dumps(walls_data), json.dumps(doors_data)))
    conn.commit()
    conn.close()

def get_building_from_database(name):
    conn = sqlite3.connect('buildings.db')
    c = conn.cursor()
    c.execute("SELECT walls_data, doors_data FROM buildings WHERE name=?", (name,))
    result = c.fetchone()
    conn.close()
    if result:
        return json.loads(result[0]), json.loads(result[1])
    else:
        return None

def heuristic(a, b):
    return np.sqrt((b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2)

def a_star_search(grid, start, goal):
    neighbors = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    close_set = set()
    came_from = {}
    gscore = {start: 0}
    fscore = {start: heuristic(start, goal)}
    oheap = []

    heapq.heappush(oheap, (fscore[start], start))
    
    while oheap:
        current = heapq.heappop(oheap)[1]

        if current == goal:
            data = []
            while current in came_from:
                data.append(current)
                current = came_from[current]
            return data[::-1]

        close_set.add(current)
        for i, j in neighbors:
            neighbor = current[0] + i, current[1] + j           
            tentative_g_score = gscore[current] + 1

            if 0 <= neighbor[0] < grid.shape[0]:
                if 0 <= neighbor[1] < grid.shape[1]:                
                    if grid[neighbor[0]][neighbor[1]] == 1:
                        continue
                else:
                    # array bound y walls
                    continue
            else:
                # array bound x walls
                continue
                
            if neighbor in close_set and tentative_g_score >= gscore.get(neighbor, 0):
                continue
                
            if  tentative_g_score < gscore.get(neighbor, 0) or neighbor not in [i[1]for i in oheap]:
                came_from[neighbor] = current
                gscore[neighbor] = tentative_g_score
                fscore[neighbor] = gscore[neighbor] + heuristic(neighbor, goal)
                heapq.heappush(oheap, (fscore[neighbor], neighbor))
                
    return False

def mark_line_high_res(x0, y0, x1, y1, grid, multiplier):
    dx = abs(x1 - x0)
    dy = -abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx + dy
    while True:
        grid[int(y0), int(x0)] = 1  # Mark the cell as a barrier
        if x0 == x1 and y0 == y1:
            break
        e2 = 2 * err
        if e2 >= dy:
            err += dy
            x0 += sx
        if e2 <= dx:
            err += dx
            y0 += sy

def mark_buffer_around_walls(grid, thickness):
    rows, cols = grid.shape
    buffer_zone = thickness  # Define the buffer zone radius
    
    # Create an off-limits grid to avoid modifying the original grid directly
    off_limits_grid = np.copy(grid)
    
    # Mark cells within the buffer zone around each wall cell as off-limits
    for y in range(rows):
        for x in range(cols):
            if grid[y, x] == 1:  # If it's a wall cell
                for dy in range(-buffer_zone, buffer_zone + 1):
                    for dx in range(-buffer_zone, buffer_zone + 1):
                        if 0 <= y + dy < rows and 0 <= x + dx < cols:
                            off_limits_grid[y + dy, x + dx] = 1  # Mark as off-limits
    return off_limits_grid

def flood_fill_with_buffer(grid, start_x, start_y, fill_value=2):
    """Modified flood fill algorithm to avoid off-limits cells."""
    rows, cols = grid.shape
    queue = deque([(start_x, start_y)])
    
    directions = [(0, -1), (0, 1), (-1, 0), (1, 0)]
    
    while queue:
        x, y = queue.popleft()
        
        if x < 0 or x >= cols or y < 0 or y >= rows or grid[y, x] != 0:
            continue
        
        grid[y, x] = fill_value
        
        for dx, dy in directions:
            queue.append((x + dx, y + dy))

def parse_floorplan_data(walls_data, doors_data):
    walls = []
    doors = []

    for wall in walls_data:
        transform = np.array(wall["transform"]).reshape(4, 4).T
        dimensions = wall["dimensions"]
        length, height, _ = dimensions

        # Position is the translation part of the transformation matrix
        position = transform[:3, 3]

        # Calculate rotation angle in radians from the transformation matrix
        # Angle = atan2(-m[0,2], m[0,0]) considering the standard rotation matrix
        rotation_angle = math.atan2(-transform[0,2], transform[0,0])
        # rotation_angle = math.atan2(-transform[1,0], transform[1,1])
        
        # Calculate the endpoints of the wall
        dx = length / 2 * math.cos(rotation_angle)
        dy = length / 2 * math.sin(rotation_angle)
        x1, y1 = position[0] - dx, position[2] - dy
        x2, y2 = position[0] + dx, position[2] + dy

        walls.append({
            "x1": x1,
            "y1": y1,
            "x2": x2,
            "y2": y2,
            "rotation_angle": rotation_angle
        })

       
    for door in doors_data:
        transform = np.array(door["transform"]).reshape(4, 4).T
        dimensions = door["dimensions"]
        length, height, _ = dimensions

        # Position is the translation part of the transformation matrix
        position = transform[:3, 3]

        # Calculate rotation angle in radians from the transformation matrix
        # Angle = atan2(-m[0,2], m[0,0]) considering the standard rotation matrix
        rotation_angle = math.atan2(-transform[0,2], transform[0,0])

        # Calculate the endpoints of the door
        dx = length / 2 * math.cos(rotation_angle)
        dy = length / 2 * math.sin(rotation_angle)
        x1, y1 = position[0] - dx, position[2] - dy
        x2, y2 = position[0] + dx, position[2] + dy

        
        doors.append({
            "x1": x1,
            "y1": y1,
            "x2": x2,
            "y2": y2,
            "rotation_angle": rotation_angle
        })
    return walls, doors

def generate_floorplan_image(walls, doors):
    # Determine grid size
    min_x = min(wall['x1'] for wall in walls + [wall for wall in walls])
    min_y = min(wall['y1'] for wall in walls + [wall for wall in walls])
    max_x = max(wall['x2'] for wall in walls + [wall for wall in walls])
    max_y = max(wall['y2'] for wall in walls + [wall for wall in walls])

    # Adjust coordinates to start from 0,0
    offset_x = abs(min(min_x, 0)) + 1
    offset_y = abs(min(min_y, 0)) + 1

    # Create a new figure
    fig, ax = plt.subplots()

    # Plot walls
    for wall in walls:
        x1, y1 = wall['x1'] + offset_x, wall['y1'] + offset_y
        x2, y2 = wall['x2'] + offset_x, wall['y2'] + offset_y
        ax.plot([x1, x2], [y1, y2], 'k-', linewidth=2)

    # Plot doors
    for door in doors:
        x1, y1 = door['x1'] + offset_x, door['y1'] + offset_y
        x2, y2 = door['x2'] + offset_x, door['y2'] + offset_y
        ax.plot([x1, x2], [y1, y2], 'b-', linewidth=2)

    # Set the aspect of the plot to be equal
    ax.set_aspect('equal')

    # Save the plot as an image
    image_path = 'floorplan.png'
    plt.savefig(image_path)

    return image_path

# Flask Endpoints
@app.route('/add_building', methods=['POST'])
def add_building():
    try:
        request_data = request.get_json()
        name = request_data['name']
        walls_data = request_data['walls']
        doors_data = request_data['doors']
        walls, doors = parse_floorplan_data(walls_data, doors_data)
        add_building_to_database(name, walls, doors)
        return jsonify({"message": "Building added to database successfully"})
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route('/find_path', methods=['POST'])
def find_path():
    try:
        request_data = request.get_json() ##when request, send 
        name = request_data['name']
        building_data = get_building_from_database(name)
        if building_data:
            walls, doors = building_data

            # Determine grid size
            min_x = min(wall['x1'] for wall in walls + [wall for wall in walls])
            min_y = min(wall['y1'] for wall in walls + [wall for wall in walls])
            max_x = max(wall['x2'] for wall in walls + [wall for wall in walls])
            max_y = max(wall['y2'] for wall in walls + [wall for wall in walls])

            # Adjust coordinates to start from 0,0 and fit in the grid
            offset_x = abs(min(min_x, 0)) + 1
            offset_y = abs(min(min_y, 0)) + 1
            # Adding a multiplier for increased resolution
            multiplier = 15  # Increase resolution by a factor of 10

            # Recalculate grid dimensions with the multiplier for higher resolution
            grid_width_high_res = int((max(max_x + offset_x, 0) + 3) * multiplier)
            grid_height_high_res = int((max(max_y + offset_y, 0) + 3) * multiplier)

            # Re-initialize the high-resolution grid
            grid_high_res = np.zeros((grid_height_high_res, grid_width_high_res))

            # Re-apply line marking for high-resolution grid
            for wall in walls:
                x0, y0 = (wall['x1'] + offset_x) * multiplier, (wall['y1'] + offset_y) * multiplier
                x1, y1 = (wall['x2'] + offset_x) * multiplier, (wall['y2'] + offset_y) * multiplier
                mark_line_high_res(int(x0), int(y0), int(x1), int(y1), grid_high_res, multiplier)

            # Preprocess the grid to mark the buffer zone around walls
            buffer_thickness = 7  # For example, stay 5 cells away from any wall
            off_limits_grid = mark_buffer_around_walls(grid_high_res, buffer_thickness)

            # Perform flood fill with buffer
            flood_fill_with_buffer(off_limits_grid, 0, 0, fill_value=1)

            # Get start and end points from the request
            start = tuple(request_data['start'])
            goal = tuple(request_data['end'])

            start = (int((start[0]+offset_x)*multiplier), int((start[1]+offset_y)*multiplier))[::-1]
            goal = (int((goal[0]+offset_x)*multiplier), int((goal[1]+offset_y)*multiplier))[::-1]

            nearby_n = 50

            while off_limits_grid[start[0], start[1]] == 1:
                # check nearby points within 10 units
                for i in range(1, nearby_n):
                    for j in range(1, nearby_n):
                        if start[0]+i < off_limits_grid.shape[0] and off_limits_grid[start[0]+i, start[1]] == 0:
                            start = (start[0]+i, start[1])
                            break
                        if start[0]-i >= 0 and off_limits_grid[start[0]-i, start[1]] == 0:
                            start = (start[0]-i, start[1])
                            break
                        if start[1]+j < off_limits_grid.shape[1] and off_limits_grid[start[0], start[1]+j] == 0:
                            start = (start[0], start[1]+j)
                            break
                        if start[1]-j >= 0 and off_limits_grid[start[0], start[1]-j] == 0:
                            start = (start[0], start[1]-j)
                            break

            while off_limits_grid[goal[0], goal[1]] == 1:
                # check nearby points within 10 units
                for i in range(1, nearby_n):
                    for j in range(1, nearby_n):
                        if goal[0]+i < off_limits_grid.shape[0] and off_limits_grid[goal[0]+i, goal[1]] == 0:
                            goal = (goal[0]+i, goal[1])
                            break
                        if goal[0]-i >= 0 and off_limits_grid[goal[0]-i, goal[1]] == 0:
                            goal = (goal[0]-i, goal[1])
                            break
                        if goal[1]+j < off_limits_grid.shape[1] and off_limits_grid[goal[0], goal[1]+j] == 0:
                            goal = (goal[0], goal[1]+j)
                            break
                        if goal[1]-j >= 0 and off_limits_grid[goal[0], goal[1]-j] == 0:
                            goal = (goal[0], goal[1]-j)
                            break

            # Run A* algorithm
            path = a_star_search(off_limits_grid, start, goal)

            # Include only the start, end, and every 50th point in the path
            path =  [path[i] for i in range(1, len(path), 10)] #+ [path[-1]]
            path = [(((x)/multiplier-offset_x), ((y)/(multiplier)-offset_y)) for y, x in path]

            # Return the path as JSON
            if path:
                return jsonify({"path": path})
            else:
                return jsonify({"message": "No path found"})
        else:
            return jsonify({"message": "Building not found in database"})
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route('/floorplan_image', methods=['POST'])
def floorplan_image():
    try:
        request_data = request.get_json()
        name = request_data['name']
        building_data = get_building_from_database(name)
        if building_data:
            walls, doors = building_data
            # Generate and get the image file path
            image_path = generate_floorplan_image(walls, doors)

            # Send the image as a response
            return send_file(image_path, mimetype='image/png')
        else:
            return jsonify({"message": "Building not found in database"})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True) ##default turn on re-loader, look over any change to files
                        ##web-based debugger
