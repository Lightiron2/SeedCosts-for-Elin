document.addEventListener('DOMContentLoaded', function() {
	const container = document.getElementById('calc-container');
	const button = document.getElementById('load-calc-button');
	const pixelBreakpoint = 1030;
	let calcLoaded = false;
	const autoLoadKey = 'loadedOnce';

	function loadCalc() {
	if (calcLoaded) return;
	container.innerHTML = `
	<iframe class="centered-iframe" src="./html_export/FertCalc.html" width="720" height="576" frameborder="0"></iframe>
	`;
	calcLoaded = true;
	console.log('Calc loaded.');
	localStorage.setItem('loadedOnce', 'done');
	}
	
	function chkAutoLoadCalc() {
		if (localStorage.getItem(autoLoadKey)) 
		{
			loadCalc();
		}
	}	
	
	button.addEventListener('click', function() {
		//if (window.innerWidth >= pixelBreakpoint)
		//{
		if (!calcLoaded)
		{
			loadCalc();
		}
		//} 
		//else
		//	{
		//	alert(`Your screen is too small (${window.innerWidth}px). The calculator requires at least ${pixelBreakpoint}px.`);
		//	}
		});
	chkAutoLoadCalc();
	//if (window.innerWidth >= pixelBreakpoint) {
    //loadCalc();
	//}

	//window.addEventListener('resize', function() {
	//if (window.innerWidth >= pixelBreakpoint && !calcLoaded)
	//{
	//	loadCalc();
	//}
	//});
});