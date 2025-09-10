using EF_task1.Models;
using Microsoft.EntityFrameworkCore;

namespace EF_task1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");

            //Scaffold - DbContext "Server=.;Database=SchoolDB;Trusted_Connection=True;TrustServerCertificate=True;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Context S2context
            //enumerable vs queriable
            S2Context c = new S2Context();
            
            //Ienumerable VS Iquerable
            //querable
            var students = c.Students.Where(x => x.DeptId == 1);
            foreach (var student in students)
            {
                Console.WriteLine($"the name is {student.Name} ID : {student.Id} ");
            }
            Console.WriteLine("===================================");
            //enumerable
            var students2 = c.Students.ToList().Where(x => x.DeptId == 1);
            foreach (var student in students2)
            {
                Console.WriteLine($"the name is {student.Name} ID : {student.Id} ");
            }
            Console.WriteLine("===================================");
            //include
            S2Context c2 = new S2Context();
            var students3 = c2.Students.Include(x => x.Dept);
            foreach (var student in students3)
            {
                Console.WriteLine($"the name is {student.Name} ID : {student.Id} dept : {student.Dept.Name}");
            }
            Console.WriteLine("===================================");
            var dept = c2.Departments.Include(x => x.Students);
            foreach (var d in dept)
            {
                Console.WriteLine($"the  Department is {d.Name} ID : {d.Id}  ");
                foreach (var student in d.Students)
                {
                    Console.WriteLine($"{student.Name} , ({d.Name})");
                }
            }
            Console.WriteLine("===================================");
            #region tracking
            S2Context c3 = new S2Context();
            var DeptToChange = c3.Departments.Find(1);
            DeptToChange.Name = ".Net";
            Console.WriteLine(c3.Entry(DeptToChange).State);
            c3.SaveChanges();
            var DeptToNotChange = c3.Departments.AsNoTracking().SingleOrDefault(x => x.Id == 2);
            DeptToNotChange.Name = "Software Development";
            Console.WriteLine(c3.Entry(DeptToNotChange).State);
            c3.SaveChanges();
            #endregion
            #region CRUD
            S2Context c4 = new S2Context();
            var deptadd = new Department() { Name = "NodeJS", Loc = "Alex" };
            c4.Departments.Add(deptadd);
            c4.SaveChanges();
            var showdepts = c4.Departments;
            foreach(var d in showdepts)
            {
                Console.WriteLine($"{d.Id} , {d.Name} ");
            }
            var studentUpdate = c4.Students.Find(3);
            studentUpdate.Name = "Yousry";
            studentUpdate.Age = 21;
            c4.SaveChanges();
            var todeleteAdepartment = c4.Departments.Find(3);
            c4.Departments.Remove(todeleteAdepartment);
            #endregion

        }

    }
}
