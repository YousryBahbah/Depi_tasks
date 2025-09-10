using System;
using System.Collections.Generic;

namespace EF_task1.Models;

public partial class Student
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public int Age { get; set; }

    public string? Adddrsss { get; set; }

    public int DeptId { get; set; }

    public virtual Department Dept { get; set; } = null!;

    public virtual ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();
}
