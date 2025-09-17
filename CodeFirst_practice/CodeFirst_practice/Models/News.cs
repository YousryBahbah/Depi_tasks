using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeFirst_practice.Models
{
    internal class News
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Breif { get; set; }
        public Catalog Cat {  get; set; }
        public  Author Author {  get; set; }
        [ForeignKey ("Cat")]
        public int Catid {  get; set; }
        [ForeignKey ("Author")]
        public int Authorid {  get; set; }
        public DateTime time { get; set; }

        public DateOnly date { get; set; }
    }
}
