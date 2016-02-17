
local parseSourceBody
local parseSourceBlock
local parseSourceStatement
local parseSourceExpression
local parseSourceType
local statements = {}

@include sourceLexer
@include sourceEnvironment
@include sourceSession

@include source-common.parseExpressionList
@include source-common.parseName
@include source-common.parseImplementationList
@include source-common.parseTypeModifier
@include source-common.parseTypename
@include source-common.parseType

@include source-definitions.parseEnumDefinition
@include source-definitions.parseDefinitions
@include source-definitions.parseFunctionDefinitionParameters
@include source-definitions.parseFunctionDefinition
@include source-definitions.parseDefinition
@include source-common.parseClassBody
@include source-definitions.parseClassDefinition
@include source-definitions.parseInterfaceDefinition
@include source-definitions.parseExtendedDefinition

@include source-common.parseNamespace

@include source-expression.parseBinaryOperator
@include source-expression.parsePrimaryExpression
@include source-expression.parseUnaryOperatorLeft
@include source-expression.parseUnaryOperatorRight
@include source-expression.parseTerm

@include source-statements.parseImportStatement
@include source-statements.parseIfStatement
@include source-statements.parseWhileStatement
@include source-statements.parseForStatement
@include source-statements.parseForeachStatement
@include source-statements.parseSuperStatement
@include source-statements.parseSwitchStatement
@include source-statements.parseReturnStatement
@include source-statements.parseBreakStatement
@include source-statements.parseContinueStatement
@include source-statements.parseThrowStatement
@include source-statements.parseTryStatement
@include source-statements.parseTypenameStatement
@include source-statements.parseUsingStatement
@include source-statements.parseNewStatement
@include source-statements.parseRepeatStatement

@include source-common.parseBlock
@include source-common.parseStatement
@include source-common.parseExpression
@include parseSourceBody

statements["import"] = parseSourceImportStatement
statements["if"] = parseSourceIfStatement
statements["while"] = parseSourceWhileStatement
statements["for"] = parseSourceForStatement
statements["foreach"] = parseSourceForeachStatement
statements["super"] = parseSourceSuperStatement
statements["switch"] = parseSourceSwitchStatement
statements["return"] = parseSourceReturnStatement
statements["break"] = parseSourceBreakStatement
statements["continue"] = parseSourceContinueStatement
statements["throw"] = parseSourceThrowStatement
statements["try"] = parseSourceTryStatement
statements["typename"] = parseSourceTypenameStatement
statements["using"] = parseSourceUsingStatement
statements["new"] = parseSourceNewStatement
statements["repeat"] = parseSourceRepeatStatement

local session = newSourceSession "Hawk/example"
local ast = session:addstr [[
namespace A {
	namespace B {
		namespace C {
			class X;
		}
	}
}
]]
local h = fs.open( "Hawk/log", "w" )
h.write( textutils.serialize( ast ) )
h.close()
