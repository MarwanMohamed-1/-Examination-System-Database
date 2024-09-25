# Examination Database System 
A robust and scalable SQL Server database designed to manage examinations, courses, instructors, and students. The system features automated exam creation, question pools, result storage, and comprehensive user roles and permissions. Developed to streamline exam management for educational institutions.

## Project Overview
The Examination System Database project aims to create a robust database system to manage exams, courses, instructors, and students. The system includes features such as a question pool, automated exam creation, and result storage.

## System Requirements
- SQL Server 2019 or higher
- SQL Server Management Studio (SSMS)
- Git

## Project Structure
- `docs/`: Contains project documentation including system requirements, ERD, and test plans.
- `scripts/`: SQL scripts for creating tables, inserting data, creating stored procedures, triggers, and views.
- `src/`: Source files for database objects, organized into subdirectories for backup, procedures, functions, tables, triggers, and views.
- `test/`: SQL scripts for testing the database, including test queries and test data.
  
```sh
ExaminationSystemDatabase/
├── .gitignore
├── README.md
├── docs/
│   ├── ERD.png
│   ├── SystemRequirements.docx
│   ├── Documentation.md
│   └── TestPlan.md
├── scripts/
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   └── views.sql
├── src/
│   ├── backup/
│   ├── procedures/
│   ├── functions/
│   ├── tables/
│   ├── triggers/
│   └── views/
└── test/
    ├── test_queries.sql
    └── test_data.sql
```


## Getting Started

### Prerequisites
- Install SQL Server 2019 or higher
- Install SQL Server Management Studio (SSMS)
- Install Git

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Ahmedmohamed106/ExaminationSystemDatabase.git
    cd ExaminationSystemDatabase
    ```

2. Open SQL Server Management Studio (SSMS) and connect to your SQL Server instance.

3. Execute the scripts in the following order:
    1. `scripts/create_tables.sql`
    2. `scripts/insert_data.sql`
    3. `scripts/stored_procedures.sql`
    4. `scripts/triggers.sql`
    5. `scripts/views.sql`

4. Verify the database setup by running the test queries in `test/test_queries.sql`.

## Usage

- **Creating Exams:** Use the stored procedures to create and manage exams.
- **Inserting Questions:** Use the `insert_data.sql` script to add questions to the question pool.
- **Viewing Results:** Use the provided views to access student results and exam data.

## Documentation

Detailed documentation is available in the `docs/` directory:
- `ERD.png`: Entity-Relationship Diagram
- `SystemRequirements.docx`: System requirements document
- `Documentation.md`: Detailed description of the database objects
- `TestPlan.md`: Test plan and test cases

## Contributing

1. Fork the repository.
2. Create a new feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## Essential Git Commands

```sh
# Clone the repository
git clone https://github.com/yourusername/ExaminationSystemDatabase.git

# Create a new branch
git checkout -b feature/YourFeature

# Commit changes
git add .
git commit -m 'Add some feature'

# Push to a branch
git push origin feature/YourFeature

# Pull the latest changes
git pull origin main

# Merge a branch
git checkout main
git merge feature/YourFeature

# Delete a branch
git branch -d feature/YourFeature

# Initialize a Git repository (if starting from scratch)
git init

# Create a .gitignore file
echo "*.log" >> .gitignore
echo "*.bak" >> .gitignore

# Create initial commit
git add .
git commit -m "Initial commit"

# Add remote repository
git remote add origin https://github.com/Ahmedmohamed106/ExaminationSystemDatabase.git

# Push initial commit to remote repository
git push -u origin main
```

## License
Not Yet.
