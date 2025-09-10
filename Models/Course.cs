using System;
using System.Collections.Generic;

namespace EF_task1.Models;

public partial class Course
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public int Credits { get; set; }

    public virtual ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();
}
