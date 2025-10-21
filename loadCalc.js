document.addEventListener('DOMContentLoaded', function() {
	const container = document.getElementById('calc-container');
	const pixelBreakpoint = 1030;
	let calcLoaded = false;

	function loadCalc() {
	if (calcLoaded) return;
	container.innerHTML = `
	<iframe class="centered-iframe" src="./html_export/FertCalc.html" width="720" height="576" frameborder="0"></iframe>
	`;
	calcLoaded = true;
	console.log('Calc loaded.');
	}

	if (window.innerWidth >= pixelBreakpoint) {
    loadCalc();
	}

	window.addEventListener('resize', function() {
	if (window.innerWidth >= pixelBreakpoint && !calcLoaded)
	{
		loadCalc();
	}
	});
});