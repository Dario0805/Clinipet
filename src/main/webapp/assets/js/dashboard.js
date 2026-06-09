document.addEventListener('DOMContentLoaded', () => {
  const main = document.getElementById('mainChart');
  if (main) new Chart(main, {type:'line',data:{labels:['Lun','Mar','Mié','Jue','Vie','Sáb','Dom'],datasets:[{label:'Ingresos',data:[12,19,15,25,32,28,38],tension:.45,fill:true},{label:'Citas',data:[8,12,10,15,18,14,20],tension:.45}]},options:{responsive:true,plugins:{legend:{position:'bottom'}},animation:{duration:1800,easing:'easeOutQuart'}}});
  const donut = document.getElementById('donutChart');
  if (donut) new Chart(donut, {type:'doughnut',data:{labels:['Consulta','Vacuna','Estética','Ventas'],datasets:[{data:[35,25,20,20]}]},options:{plugins:{legend:{position:'bottom'}},animation:{animateScale:true,animateRotate:true,duration:1600}}});
});
