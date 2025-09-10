using System;
using System.Collections.Generic;

namespace EF_task1.Models;

public partial class Department
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Loc { get; set; }

    public virtual ICollection<Student> Students { get; set; } = new List<Student>();
}
