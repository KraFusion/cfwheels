<cfoutput>

  <cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">

  <h1>Test Results</h1>

  <cfif NOT isStruct(testResults)>

  	<p style="margin-bottom: 50px;">Sorry, no tests were found.</p>

  <cfelse>

  	<p><a href="#linkParams#">Run All Tests</a> | <a href="#linkParams#&reload=true">Reload Test Data</a></p>

  	<table class="testing">
  		<tr>
  			<th class="<cfif testResults.ok>success<cfelse>failed</cfif>">Status</th>
  			<td class="numeric <cfif testResults.ok>success<cfelse>failed</cfif>"><cfif testResults.ok>Passed<cfelse>Failed</cfif></td>
  		</tr>
  		<tr>
  			<th>Duration</th>
  			<td class="n">#TimeFormat(testResults.end - testResults.begin, "HH:mm:ss")#</td>
  		</tr>
  			<tr>
  				<th>Packages</th>
  				<td class="n">#testResults.numCases#</td>
  			</tr>
  		<tr>
  			<th>Tests</th>
  			<td class="n">#testResults.numTests#</td>
  		</tr>
  		<tr>
  			<th<cfif testResults.numFailures neq 0> class="failed"</cfif>>Failures</th>
  			<td class="n<cfif testResults.numFailures neq 0> failed</cfif>">#testResults.numFailures#</td>
  		</tr>
  		<tr>
  			<th<cfif testResults.numErrors neq 0> class="failed"</cfif>>Errors</th>
  			<td class="n<cfif testResults.numErrors neq 0> failed</cfif>">#testResults.numErrors#</td>
  		</tr>
  	</table>

  	<table class="testing">
  		<tr>
  			<th>Package</th>
  			<th>Tests</th>
  			<th>Failures</th>
  			<th>Errors</th>
  		</tr>
  		<cfloop from="1" to="#ArrayLen(testResults.summary)#" index="testIndex">
  			<cfset summary = testResults.summary[testIndex]>
  			<tr class="<cfif summary.numFailures + summary.numErrors gt 0>errRow<cfelse>sRow</cfif>">
  				<td>
  					<cfset a = ListToArray(summary.packageName, ".")>
  					<cfset b = CreateObject("java", "java.util.ArrayList").Init(a)>
  					<cfset c = ArrayLen(a)>
  					<cfloop from="1" to="#c#" index="i"><a href="#linkParams#&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">#a[i]#</a><cfif i neq c>.</cfif></cfloop>
  				</td>
  				<td class="n">#summary.numTests#</td>
  				<td class="n<cfif summary.numFailures neq 0> failed</cfif>">#summary.numFailures#</td>
  				<td class="n<cfif summary.numErrors neq 0> failed</cfif>">#summary.numErrors#</td>
  			</tr>
  		</cfloop>
  	</table>

  	<table class="testing">
  		<tr>
  			<th>Package</th>
  			<th>Test Name</th>
  			<th>Time</th>
  			<th>Status</th>
  		</tr>
  		<cfloop from="1" to="#arrayLen(testResults.results)#" index="testIndex">
  			<cfset result = testResults.results[testIndex]>
  			<tr class="<cfif result.status neq 'Success'>errRow<cfelse>sRow</cfif>">
  				<td><a href="#linkParams#&package=#result.packageName#">#result.cleanTestCase#</a></td>
  				<td><a href="#linkParams#&package=#result.packageName#&test=#result.testName#">#result.cleanTestName#</a></td>
  				<td class="n">#result.time#</td>
  				<td class="<cfif result.status eq 'Success'>success<cfelse>failed</cfif>">#result.status#</td>
  			</tr>
  			<cfif result.status neq "Success">
  				<tr class="errRow"><td colspan="4" class="failed">#replace(result.message, chr(10), "<br/>", "ALL")#</td></tr>
  			</cfif>
  			<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], result.testName)>
  				<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][result.testName]#" index="i">
  				<tr class="<cfif result.status neq 'Success'>errRow<cfelse>sRow</cfif>"><td colspan="4">#i#</tr>
  				</cfloop>
  			</cfif>
  		</cfloop>
  	</table>

  </cfif>
</cfoutput>
