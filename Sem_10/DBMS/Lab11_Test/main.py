from flask import Flask, render_template, request, redirect, url_for
import sqlite3  

app = Flask(__name__)
connection = sqlite3.connect('subject_dep.db', check_same_thread=False)

def initialise_db():

    cursor = connection.cursor()

    # Creating department table
    cursor.execute(''' CREATE TABLE IF NOT EXISTS Department (
            Dept_cd INTEGER PRIMARY KEY AUTOINCREMENT,
            Dept_name VARCHAR(50) NOT NULL,
            Dept_HOD VARCHAR(50) NOT NULL,
            Dept_Loc VARCHAR(50) NOT NULL
        );'''
    )

    # Creating subject table
    cursor.execute(''' CREATE TABLE IF NOT EXISTS Subject (
            Subject_cd INTEGER PRIMARY KEY AUTOINCREMENT,
            Subject_name VARCHAR(20) NOT NULL,
            Subject_cred INTEGER NOT NULL,
            Subject_dur INTEGER,
            Fac_name VARCHAR(20) NOT NULL
        );'''
    )

    # Creating Department_Subject table
    cursor.execute(''' CREATE TABLE IF NOT EXISTS Department_Subject (
            Dept_cd INTEGER,
            Subject_cd INTEGER,
            PRIMARY KEY (Dept_cd, Subject_cd),
            FOREIGN KEY (Dept_cd) REFERENCES Department(Dept_cd),
            FOREIGN KEY (Subject_cd) REFERENCES Subject(Subject_cd)
        );'''
    )

    connection.commit()


@app.route('/')
def main():
    return render_template('Main.html')

@app.route('/addDepartment', methods=['post', 'get'])
def addDep():

    if request.method == "POST":
        
        name = request.form.get('DepName')
        hod = request.form.get('DepHod')
        location = request.form.get('DepLocation')
        query = ''' INSERT INTO Department VALUES ({}, '{}', '{}', '{}') '''

        cursor = connection.cursor()
        cursor.execute(query.format("NULL", name, hod, location))
        
        print("Inserted Department")    
        connection.commit()

    return render_template('DepTable.html')


@app.route('/addSubject', methods=['post', 'get'])
def addSub():

    if request.method == "POST":
        
        name = request.form.get('SubName')
        creds = request.form.get('SubCreds')
        duration = request.form.get('SubDuration')
        faculty = request.form.get('SubFac')
        deps = request.form.get('OfferBy')
        query = ''' INSERT INTO Subject VALUES ({}, '{}', {}, {}, '{}') '''

        cursor = connection.cursor()
        cursor.execute(query.format("NULL", name, creds, duration, faculty))
        query = ''' 
                SELECT Subject_cd
                FROM Subject
                WHERE Subject_name = '{}'
            '''
        results = cursor.execute(query.format(name))
        for row in results:
            sub_id = str(row)[1:-2]
            break
        print("Inserted Subject ({})".format(sub_id))    

        deps = deps.strip().split(',')
        dep_ids = []
        for dep in deps:
            dep = dep.strip()
            query = ''' 
                SELECT Dept_cd
                FROM Department
                WHERE Dept_name = '{}'
            '''
            results = cursor.execute(query.format(dep))
            for row in results:
                dep_ids.append(str(row)[1:2])
                break

        query = ''' INSERT INTO Department_Subject VALUES ({}, {}) '''
        for dep in dep_ids:
            cursor.execute(query.format(dep, sub_id))
            print("Inserted subject dep pair({}, {})".format(dep, sub_id))
        connection.commit()

    return render_template('SubjectTable.html')

@app.route('/search')
def search():
    query = request.args.get('SubName')
    sqlQuery = ''' 
        SELECT * 
        FROM Department as D, Subject as S, Department_Subject as DS
        WHERE D.Dept_cd = DS.Dept_cd AND S.Subject_cd = DS.Subject_cd AND D.Dept_name LIKE '%{}%'
    '''
    cursor = connection.cursor()
    results = cursor.execute(sqlQuery.format(query))
    return str(cursor.fetchall())


# main driver function
if __name__ == '__main__':
    initialise_db()
    app.run()